# frozen_string_literal: true

module ProviderGenerator
  Operation = Data.define(:method, :path, :id, :summary, :parameters, :request_schema, :request_example, :request_examples,
                          :responses, :tags, :security, :content_type, :inbound)

  Model = Data.define(:provider, :title, :base_url, :servers, :operations, :security_schemes, :create_operation,
                      :status_operation, :webhook_operation, :statuses, :errors, :webhook_signature,
                      :amount_multiplier, :overrides, :role_scores, :warnings) do
    def class_name
      provider.split(/[^a-zA-Z0-9]+/).reject(&:empty?).map(&:capitalize).join
    end

    def env_prefix
      provider.gsub(/[^a-zA-Z0-9]+/, "_").upcase
    end

    def auth_summary
      return "не объявлена" if security_schemes.empty?
      security_schemes.map do |name, scheme|
        details = if scheme["type"] == "apiKey"
                    "#{scheme['in']} #{scheme['name']}"
                  elsif scheme["type"] == "http"
                    scheme["scheme"]
                  elsif scheme["type"] == "oauth2"
                    "сценарии: #{scheme.fetch('flows', {}).keys.join(', ')}"
                  end
        "#{name} (#{[scheme['type'], details].compact.join(': ')})"
      end.join(", ")
    end
  end

  class Analyzer
    HTTP_METHODS = %w[get post put patch delete options head trace].freeze
    DEFAULT_STATUS_MAP = {
      "pending" => "in_progress", "processing" => "in_progress", "created" => "in_progress",
      "waiting_for_capture" => "in_progress", "payment_pending" => "in_progress", "active" => "in_progress",
      "new" => "in_progress", "authentication_finished" => "in_progress",
      "authentication_not_required" => "in_progress", "challenge_shopper" => "in_progress",
      "identify_shopper" => "in_progress", "partially_authorised" => "in_progress",
      "present_to_shopper" => "in_progress", "redirect_shopper" => "in_progress",
      "completed" => "approved", "complete" => "approved", "succeeded" => "approved", "paid" => "approved",
      "failed" => "rejected", "cancelled" => "rejected", "canceled" => "rejected", "declined" => "rejected", "rejected" => "rejected",
      "expired" => "rejected", "refused" => "rejected", "error" => "rejected",
      "authorised" => "approved", "authorized" => "approved", "received" => "in_progress", "success" => "approved",
      "requested" => "in_progress", "initiated" => "in_progress", "processing_at_bank" => "in_progress",
      "pending_approval" => "in_progress", "pending_parent_batch_approval" => "in_progress",
      "ready_for_processing" => "in_progress", "open" => "in_progress",
      "quoted" => "in_progress", "validating" => "in_progress", "transferring" => "in_progress",
      "awaiting_funding" => "in_progress", "in_transit" => "in_progress", "saved" => "in_progress",
      "payer_action_required" => "in_progress", "partially_captured" => "in_progress",
      "paying" => "in_progress", "bill" => "in_progress",
      "3_ds_checking" => "in_progress", "3_ds_checked" => "in_progress", "form_showed" => "in_progress",
      "approved" => "approved", "deposited" => "approved", "captured" => "approved", "vaulted" => "approved",
      "returned" => "rejected", "reversed" => "rejected", "refunded" => "rejected",
      "confirmed" => "approved",
      "denied" => "rejected", "voided" => "rejected", "errored" => "rejected", "deleted" => "rejected",
      "partial_refunded" => "rejected", "deadline_expired" => "rejected"
    }.freeze

    def initialize(spec, provider:, overrides: {})
      @spec = spec
      @provider = provider
      @overrides = overrides
    end

    def call
      operations = extract_operations
      create, create_scores = choose_create(operations)
      create, create_scores = apply_operation_override("create", operations, create, create_scores) if operation_overridden?("create")
      status, status_scores = choose_status(operations, create)
      status, status_scores = apply_operation_override("status", operations, create, status_scores) if operation_overridden?("status")
      webhook = operations.find { |operation| incoming_webhook?(operation) }
      webhook = find_overridden_operation("webhook", operations) if operation_overridden?("webhook")
      warnings = []
      warnings << "Не удалось определить операцию создания платежа или выплаты." unless create
      warnings << "Не удалось определить операцию проверки статуса." unless status
      warnings << "Не удалось определить входящий webhook." unless webhook
      warnings << ambiguity_warning("создания", create_scores) if create && ambiguous?(create_scores) && !operation_overridden?("create")
      warnings << ambiguity_warning("проверки статуса", status_scores) if status && ambiguous?(status_scores) && !operation_overridden?("status")
      warnings << "Авторизация через Token/signature в теле запроса требует явной настройки для провайдера." if body_token_auth?(create)
      [create, status].compact.uniq.each do |operation|
        next if operation.security.nil? || operation.security == [] || supported_security?(operation)
        warnings << "Для #{operation.method.upcase} #{operation.path} не поддерживается объявленная схема авторизации; требуется явная реализация."
      end
      warnings << "Обнаружены внешние $ref. Они сохранены без сетевой загрузки; перед генерацией объедините схемы или подтвердите локальные копии." if external_references?(@spec)
      warnings.concat(semantic_ambiguities(create, webhook))
      unknown_required_mappings(create).each do |path|
        warnings << "TODO field_map #{path}: поле API не входит в подтверждённую схему operation/payout_requisite; задайте явный источник в overrides."
      end
      statuses = extract_statuses(create, status, webhook)
      effective_status_map = DEFAULT_STATUS_MAP.merge(@overrides.fetch("status_map", {}).transform_keys { |key| normalized_status(key) })
      unmapped = statuses.reject { |item| effective_status_map.key?(normalized_status(item)) }
      warnings << "Не сопоставлены статусы: #{unmapped.join(', ')}. Добавьте подтверждённые соответствия в status_map overrides." unless unmapped.empty?

      Model.new(
        provider: @provider, title: @spec.dig("info", "title") || @provider,
        base_url: @spec.dig("servers", 0, "url") || "https://api.example.invalid",
        servers: Array(@spec["servers"]),
        operations: operations, security_schemes: @spec.dig("components", "securitySchemes") || {},
        create_operation: create, status_operation: status, webhook_operation: webhook,
        statuses: statuses.to_h { |item| [item, mapped_status(item)] }.merge(@overrides.fetch("status_map", {})),
        errors: extract_errors(operations).merge(integer_keyed(@overrides.fetch("error_map", {}))),
        webhook_signature: effective_signature(webhook),
        amount_multiplier: configured_amount_multiplier, overrides: @overrides,
        role_scores: { "create" => create_scores, "status" => status_scores }, warnings: warnings
      )
    end

    private

    def operation_overridden?(role)
      @overrides.fetch("operations", {}).key?(role)
    end

    def find_overridden_operation(role, operations)
      selector = @overrides.fetch("operations").fetch(role)
      matches = operations.select do |operation|
        if selector["operation_id"]
          operation.id.to_s == selector["operation_id"].to_s
        else
          operation.method.to_s.casecmp?(selector["method"].to_s) && operation.path.to_s == selector["path"].to_s
        end
      end
      description = selector["operation_id"] || "#{selector['method'].to_s.upcase} #{selector['path']}"
      raise Error, "operations.#{role}: операция #{description} не найдена в спецификации." if matches.empty?
      raise Error, "operations.#{role}: выбор #{description} соответствует нескольким операциям." if matches.length > 1

      matches.first
    end

    def apply_operation_override(role, operations, create_context, _scores)
      selected = find_overridden_operation(role, operations)
      scorer = role == "create" ? method(:create_score) : ->(operation) { status_score(operation, create_context) }
      alternatives = operations.reject { |operation| operation.equal?(selected) || incoming_webhook?(operation) }
      runner_up = rank(alternatives, &scorer).first
      selected_score = scorer.call(selected)
      summary = {
        "selected" => operation_score_entry(selected, selected_score).merge("source" => "overrides"),
        "runner_up" => runner_up && operation_score_entry(runner_up[1], runner_up[0]),
        "margin" => runner_up ? selected_score - runner_up[0] : nil
      }
      [selected, summary]
    end

    def operation_score_entry(operation, score)
      { "score" => score, "method" => operation.method, "path" => operation.path, "operation_id" => operation.id }
    end

    def extract_operations
      [[@spec.fetch("paths"), false], [@spec.fetch("webhooks", {}), true]].flat_map do |collection, inbound|
        collection.flat_map do |path, item|
          HTTP_METHODS.filter_map do |method|
            operation = item[method]
            next unless operation.is_a?(Hash)
            parameters = Array(item["parameters"]) + Array(operation["parameters"])
            content = operation.dig("requestBody", "content") || {}
            content_type, media = preferred_media(content)
            examples = media_examples(media)
            Operation.new(method: method, path: path, id: operation["operationId"] || "#{method}_#{path}",
                          summary: (operation["summary"] || operation["description"]).to_s, parameters: parameters,
                          request_schema: media["schema"] || {}, request_example: examples.values.first,
                          request_examples: examples,
                          responses: operation["responses"] || {}, tags: Array(operation["tags"]),
                          security: operation.key?("security") ? operation["security"] : @spec["security"],
                          content_type: content_type || "application/json", inbound: inbound)
          end
        end
      end
    end

    def media_examples(media)
      examples = media.fetch("examples", {}).to_h.transform_values do |candidate|
        candidate.is_a?(Hash) && candidate.key?("value") ? candidate["value"] : candidate
      end
      examples = { "default" => media["example"] } if examples.empty? && media.key?("example")
      examples.reject { |_, value| value.nil? }
    end

    def preferred_media(content)
      type = ["application/json", "application/x-www-form-urlencoded", "multipart/form-data"].find { |candidate| content.key?(candidate) }
      type ||= content.keys.first
      [type, type ? content[type] : {}]
    end

    def choose_create(operations)
      ranked = rank(operations.reject { |op| incoming_webhook?(op) }) { |op| create_score(op) }
      score, operation = ranked.first
      [score.to_i >= 15 ? operation : nil, score_summary(ranked)]
    end

    def choose_status(operations, create)
      ranked = rank(operations.reject { |op| incoming_webhook?(op) }) { |op| status_score(op, create) }
      score, operation = ranked.first
      [score.to_i >= 25 ? operation : nil, score_summary(ranked)]
    end

    def create_score(operation)
      text = [operation.id, operation.summary, operation.path].join(" ")
      score = operation.method == "post" ? 5 : -20
      score += 30 if operation.path.match?(%r{/(?:payments?|payouts?|withdrawals?|disbursements?|transfers?|init)/?$}i)
      score += 14 if text.match?(/batch.?payment|пакет.*плат/i)
      score += 18 if text.match?(/create|register|initialize|initiate|созда|регистр|инициализ|\binit\b/i)
      score += 26 if text.match?(/payout|withdrawal|disbursement|выплат|вывод/i)
      score += 8 if text.match?(/payment|transfer|плат[её]ж|перевод/i)
      score += 8 unless operation.request_schema.empty?
      score += 8 if schema_property?(operation.request_schema, /\Aamount\z/i)
      score += 4 if schema_property?(operation.request_schema, /\Acurrency\z/i)
      score += 4 if operation.parameters.any? { |parameter| parameter["name"].to_s.match?(/idempot/i) }
      score += 5 if successful_response_property?(operation, /\A(?:id|payment_?id|payout_?id|order_?id)\z/i)
      score -= 25 if text.match?(/cancel|capture|refund|receipt|возврат|чек|отмен|link|getstate|details|method|track/i)
      score -= 12 if text.match?(/list|search|retrieve|fetch/i)
      score
    end

    def status_score(operation, create = nil)
      text = [operation.id, operation.summary, operation.path].join(" ")
      score = operation.method == "get" ? 4 : 0
      score += 45 if text.match?(/(?:get|fetch|check|retrieve|query|получ|провер).*(?:state|status|состояни|статус)/i)
      score += 20 if operation.id.match?(/\A(?:get|fetch|check|retrieve|query)?(?:payment|payout|order|transaction)?(?:state|status)(?:extended)?\z/i)
      score += 18 if text.match?(/get(payment|payout)|paymentstatus|payoutstatus/i)
      score += 10 if operation.path.match?(%r!/(payments?|payouts?)/\{[^}]+\}/?$!i)
      score += 35 if create && operation.method == "get" && member_of_collection?(operation.path, create.path)
      score += 12 unless primary_status_values(operation).empty?
      score += 6 if operation.parameters.any? { |parameter| parameter["in"] == "path" }
      score -= 20 if text.match?(/list|search|link|method|cancel|capture|refund/i)
      if create && (domain = create.path.match(%r{/(payouts?|p2p|withdrawals?|disbursements?)(?:/|\z)}i))
        score -= 65 unless operation.path.match?(%r{/#{Regexp.escape(domain[1])}(?:/|\z)}i)
      end
      score
    end

    def rank(operations)
      operations.map { |operation| [yield(operation), operation] }
                .sort_by { |score, operation| [-score, operation.path, operation.method, operation.id] }
    end

    def score_summary(ranked)
      best, second = ranked.first(2)
      return {} unless best
      {
        "selected" => { "score" => best[0], "method" => best[1].method, "path" => best[1].path, "operation_id" => best[1].id },
        "runner_up" => second && { "score" => second[0], "method" => second[1].method, "path" => second[1].path, "operation_id" => second[1].id },
        "margin" => second ? best[0] - second[0] : nil
      }
    end

    def ambiguous?(scores)
      scores.dig("selected", "score").to_i.positive? && scores["margin"] && scores["margin"] < 8
    end

    def ambiguity_warning(role, scores)
      selected = scores.fetch("selected")
      runner_up = scores.fetch("runner_up")
      "Неоднозначный выбор операции #{role}: #{selected['method'].upcase} #{selected['path']} — оценка #{selected['score']}; " \
        "следующий кандидат #{runner_up['method'].upcase} #{runner_up['path']} — оценка #{runner_up['score']}; разница #{scores['margin']}. Проверьте выбор вручную."
    end

    def member_of_collection?(member_path, collection_path)
      collection = Regexp.escape(collection_path.sub(%r{/$}, ""))
      member_path.match?(Regexp.new("\\A#{collection}/\\{[^}]+\\}/?\\z"))
    end

    def schema_property?(schema, pattern, seen = {})
      return false unless schema.is_a?(Hash)
      return false if seen[schema.object_id]
      seen[schema.object_id] = true

      resolved = remaining_reference(schema)
      return schema_property?(resolved, pattern, seen) if resolved && !resolved.equal?(schema)
      return true if schema.fetch("properties", {}).keys.any? { |name| name.to_s.match?(pattern) }

      schema.fetch("properties", {}).values.any? { |child| schema_property?(child, pattern, seen) } ||
        %w[allOf oneOf anyOf].any? { |key| Array(schema[key]).any? { |part| schema_property?(part, pattern, seen) } }
    end

    def successful_response_property?(operation, pattern)
      operation.responses.any? do |code, response|
        code.to_s.match?(/\A2\d\d\z/) && response.fetch("content", {}).values.any? do |media|
          schema_property?(media["schema"] || {}, pattern)
        end
      end
    end

    def incoming_webhook?(operation)
      return true if operation.inbound
      text = [operation.path, operation.id, operation.summary, *operation.tags].join(" ")
      return false unless operation.method == "post" && text.match?(/webhook|callback|notification|уведом/i)
      return false if text.match?(/create|register|список|созда|удал|настро/i)
      operation.security.nil? || operation.security == [] || schema_has_event_payload?(operation.request_schema)
    end

    def schema_has_event_payload?(schema)
      properties = schema.fetch("properties", {})
      properties.key?("event") || (properties.key?("status") && properties.keys.any? { |key| key.match?(/payment|payout|object|id/i) })
    end

    def find_enums_in_responses(operation, key)
      operation.responses.values.flat_map do |response|
        response.fetch("content", {}).values.flat_map { |media| find_enums(media["schema"] || {}, key) }
      end
    end

    def body_token_auth?(operation)
      operation && operation.request_schema.fetch("properties", {}).keys.any? { |key| key.match?(/\A(token|signature)\z/i) }
    end

    def supported_security?(operation)
      Array(operation.security).flat_map(&:keys).any? do |name|
        scheme = @spec.dig("components", "securitySchemes", name) || {}
        (scheme["type"] == "apiKey" && scheme["in"] == "header") ||
          (scheme["type"] == "http" && %w[basic bearer].include?(scheme["scheme"].to_s.downcase))
      end
    end

    def external_references?(value, seen = {})
      return false if (value.is_a?(Hash) || value.is_a?(Array)) && seen[value.object_id]
      seen[value.object_id] = true if value.is_a?(Hash) || value.is_a?(Array)
      case value
      when Hash
        return true if value["$ref"].to_s.match?(%r{\Ahttps?://})
        value.values.any? { |child| external_references?(child, seen) }
      when Array then value.any? { |child| external_references?(child, seen) }
      else false
      end
    end

    def extract_statuses(*operations)
      operations.compact.flat_map do |operation|
        response_values = operation.responses.select { |code, _| code.to_s.match?(/\A2\d\d\z/) }.values.flat_map do |response|
          response.fetch("content", {}).values.flat_map { |media| primary_statuses(media["schema"] || {}) + example_statuses(media) }
        end
        response_values + primary_statuses(operation.request_schema) + example_statuses("example" => operation.request_example)
      end.map(&:to_s).uniq
    end

    def example_statuses(media)
      examples = [media["example"]] + media.fetch("examples", {}).values.map { |item| item.is_a?(Hash) ? item["value"] : nil }
      examples.filter_map do |example|
        next unless example.is_a?(Hash)
        pair = example.find { |name, _| name.to_s.match?(/\A(status|result_?code)\z/i) }
        pair&.last
      end
    end

    def primary_status_values(operation)
      operation.responses.select { |code, _| code.to_s.match?(/\A2\d\d\z/) }.values.flat_map do |response|
        response.fetch("content", {}).values.flat_map { |media| primary_statuses(media["schema"] || {}) }
      end
    end

    def primary_statuses(schema, seen = {})
      return [] unless schema.is_a?(Hash)
      return [] if seen[schema.object_id]
      seen[schema.object_id] = true

      resolved = remaining_reference(schema)
      return primary_statuses(resolved, seen) if resolved && !resolved.equal?(schema)

      composed = %w[allOf oneOf anyOf].flat_map do |key|
        Array(schema[key]).flat_map { |part| primary_statuses(part, seen) }
      end
      properties = schema.fetch("properties", {})
      direct = properties.flat_map do |name, value|
        if primary_status_field?(name)
          schema_values(value)
        elsif status_wrapper?(name)
          primary_statuses(value, seen)
        else
          []
        end
      end
      (composed + direct).uniq
    end

    def primary_status_field?(name)
      %w[status state payment_status payout_status order_status payment_state transaction_status result_code resultcode]
        .include?(normalized_field(name))
    end

    def status_wrapper?(name)
      %w[payment payout order batch transaction data result payment_amount_info].include?(normalized_field(name))
    end

    def normalized_field(name)
      name.to_s.gsub(/([a-z\d])([A-Z])/, "\\1_\\2").downcase.tr(" -", "__")
    end

    def schema_values(schema, seen = {})
      return [] unless schema.is_a?(Hash)
      return [] if seen[schema.object_id]
      seen[schema.object_id] = true
      resolved = remaining_reference(schema)
      return schema_values(resolved, seen) if resolved && !resolved.equal?(schema)

      explicit = Array(schema["enum"] || schema["x-extensible-enum"])
      samples = [schema["example"], schema["default"]].compact
      described = schema.fetch("description", "").scan(/`([A-Za-z0-9_-]+)`/).flatten
      described += schema.fetch("description", "").scan(/\b[A-Z][A-Z0-9_]{2,}\b/)
      common_acronyms = %w[API HTTP HTTPS URL URI ID IDS JSON XML HMAC SHA ACS CVV AVS RUB USD EUR]
      described.select! do |value|
        value.match?(/\A\d+\z/) || value.match?(/\A[A-Z][A-Z0-9_]{2,}\z/) ||
          DEFAULT_STATUS_MAP.key?(normalized_status(value))
      end
      composed = %w[allOf oneOf anyOf].flat_map do |key|
        Array(schema[key]).flat_map { |part| schema_values(part, seen) }
      end
      (explicit + samples + described + composed).reject { |value| common_acronyms.include?(value.to_s) }.uniq
    end

    def remaining_reference(schema)
      reference = schema["$ref"]
      return schema unless reference&.start_with?("#/")

      reference.delete_prefix("#/").split("/").reduce(@spec) do |node, token|
        break unless node.is_a?(Hash)
        node[token.gsub("~1", "/").gsub("~0", "~")]
      end
    end

    def normalized_status(value)
      value.to_s.gsub(/([a-z\d])([A-Z])/, "\\1_\\2").downcase.tr(" -", "__")
    end

    def mapped_status(value)
      overrides = @overrides.fetch("status_map", {}).transform_keys { |key| normalized_status(key) }
      DEFAULT_STATUS_MAP.merge(overrides).fetch(normalized_status(value), "unknown")
    end

    def find_enums(value, key = nil, seen = {})
      return [] if (value.is_a?(Hash) || value.is_a?(Array)) && seen[value.object_id]
      seen[value.object_id] = true if value.is_a?(Hash) || value.is_a?(Array)

      case value
      when Hash
        own = key.to_s.match?(/status/i) ? Array(value["enum"]) : []
        own + value.flat_map { |child_key, child| find_enums(child, child_key, seen) }
      when Array then value.flat_map { |child| find_enums(child, key, seen) }
      else []
      end
    end

    def extract_errors(operations)
      operations.each_with_object({}) do |operation, result|
        operation.responses.each_key do |code|
          next unless code.to_i >= 400
          result[code.to_i] ||= http_error_name(code.to_i)
        end
      end.sort.to_h
    end

    def http_error_name(code)
      { 400 => "bad_request", 401 => "unauthorized", 402 => "unprocessable_entity", 403 => "forbidden",
        404 => "bad_request", 409 => "unprocessable_entity", 422 => "unprocessable_entity",
        429 => "too_many_requests", 500 => "internal_server_error" }.fetch(code, "internal_server_error")
    end

    def extract_signature(webhook)
      return unless webhook
      header = webhook.parameters.find { |parameter| parameter["in"] == "header" && parameter["name"].to_s.match?(/signature/i) }
      text = [webhook.summary, header&.dig("description")].compact.join(" ")
      algorithm = text[/HMAC[-_ ]?SHA[-_ ]?\d+/i]&.upcase&.gsub(/[ _]/, "-")
      result = [header&.dig("name"), algorithm].compact.join(" / ")
      result.empty? ? nil : result
    end

    def amount_multiplier(operation)
      amount = operation&.request_schema&.fetch("properties", {})&.find { |name, _| name.to_s.casecmp?("amount") }&.last
      description = amount&.fetch("description", "").to_s
      description.match?(/копей|kopeck|minor unit/i) ? 100 : 1
    end

    def configured_amount_multiplier
      Integer(@overrides.dig("amount", "multiplier") || 1)
    rescue ArgumentError, TypeError
      1
    end

    def effective_signature(webhook)
      configured = @overrides.fetch("webhook_signature", {})
      return extract_signature(webhook) if configured.empty?

      [configured["header"], configured["algorithm"], configured["encoding"], "проверка платформой до разбора JSON"].compact.join(" / ")
    end

    def semantic_ambiguities(create, webhook)
      warnings = []
      amount_description = create&.request_schema&.fetch("properties", {})&.find { |name, _| name.to_s.casecmp?("amount") }&.last&.fetch("description", "").to_s
      if amount_description.match?(/копей|kopeck|minor unit/i) && !@overrides.dig("amount", "multiplier")
        warnings << "TODO amount_unit: единица суммы указана только в description; подтвердите её в overrides."
      end

      conditional_descriptions(create&.request_schema || {}).each do |path|
        next if Array(@overrides["required_if"]).any? { |rule| rule["field"] == path }
        warnings << "TODO required_if #{path}: условная обязательность указана только в description; подтвердите правило в overrides."
      end

      detected = extract_signature(webhook)
      signature = @overrides.fetch("webhook_signature", {})
      if detected && !(%w[algorithm encoding] - signature.keys).empty?
        warnings << "TODO webhook_signature: подтвердите алгоритм и encoding в overrides; исходное тело недоступно внутри process_callback."
      end
      warnings
    end

    def unknown_required_mappings(operation)
      mappings = @overrides.fetch("field_map", {})
      fields = required_schema_fields(operation&.request_schema || {})
      fields += Array(@overrides["required_if"]).filter_map do |rule|
        find_schema_field(operation&.request_schema || {}, rule["field"])&.then { |schema| [rule["field"], schema] }
      end
      fields.uniq.filter_map do |path, schema|
        path unless mappings.key?(path) || known_platform_mapping?(path, schema)
      end
    end

    def required_schema_fields(schema, prefix = nil, seen = {})
      return [] unless schema.is_a?(Hash)
      return [] if seen[schema.object_id]
      branch_seen = seen.merge(schema.object_id => true)
      properties = schema.fetch("properties", {})
      direct = Array(schema["required"]).flat_map do |name|
        path = [prefix, name].compact.join(".")
        child = properties[name] || {}
        nested = required_schema_fields(child, path, branch_seen)
        nested.empty? && child.fetch("properties", {}).empty? ? [[path, child]] : nested
      end
      composed = Array(schema["allOf"]).flat_map { |part| required_schema_fields(part, prefix, branch_seen) }
      direct + composed
    end

    def find_schema_field(schema, path)
      path.to_s.split(".").reduce(schema) do |node, key|
        break unless node.is_a?(Hash)
        node.fetch("properties", {})[key]
      end
    end

    def known_platform_mapping?(path, schema)
      return true if %w[amount external_id merchant_operation_id recipient.type recipient.phone recipient.bank_code recipient.bank_name recipient.card_number].include?(path)
      Array(schema["enum"]).one? || schema.key?("default")
    end

    def conditional_descriptions(schema, prefix = nil, seen = {})
      return [] unless schema.is_a?(Hash)
      return [] if seen[schema.object_id]
      seen[schema.object_id] = true

      schema.fetch("properties", {}).flat_map do |name, child|
        path = [prefix, name].compact.join(".")
        description = child.fetch("description", "").to_s
        own = description.match?(/(?:обязател|required).*(?:type\s*=|when|если|для\s+type)/i) ? [path] : []
        own + conditional_descriptions(child, path, seen)
      end
    end

    def integer_keyed(value)
      value.to_h { |key, item| [Integer(key), item] }
    end
  end
end
