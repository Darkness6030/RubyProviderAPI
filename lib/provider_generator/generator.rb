# frozen_string_literal: true

require "fileutils"
require "json"

module ProviderGenerator
  class Generator
    def initialize(model, output:, documentation_output: output)
      @model = model
      @output = output
      @documentation_output = documentation_output
    end

    def call
      FileUtils.mkdir_p(@output)
      FileUtils.mkdir_p(@documentation_output)
      files = {
        File.join(@output, "#{snake(@model.provider)}_service.rb") => service,
        File.join(@documentation_output, "INTEGRATION.md") => guide,
        File.join(@output, "fixtures.json") => JSON.pretty_generate(fixtures) + "\n"
      }
      files.each { |path, content| File.write(path, content) }
      files.keys
    rescue SystemCallError => e
      raise Error, "Не удалось записать результат: #{e.message}"
    end

    private

    def service
      create = @model.create_operation
      status = @model.status_operation
      webhook = @model.webhook_operation
      create_auth = auth_for(create)
      status_auth = auth_for(status)
      <<~RUBY
        # frozen_string_literal: true
        # Сгенерировано из #{@model.title}. Перед production-использованием проверьте маппинг полей.

        require "json"
        require "base64"
        require "bigdecimal"
        require "uri"

        class Provider
          class #{@model.class_name}Service < BaseService
            BASE_URL = ENV.fetch("#{@model.env_prefix}_BASE_URL", #{@model.base_url.inspect})
            STATUS_MAP = #{ruby_literal(@model.statuses)}.freeze
            ERROR_MAP = #{ruby_literal(@model.errors)}.freeze
            WEBHOOK_EVENTS = #{ruby_literal(webhook_events(webhook))}.freeze

            def create_request(operation, request_method = nil)
              return failure(:internal_server_error, "provider.create_operation_missing") unless #{!create.nil?}

              path = expand_path(#{create&.path.inspect}, operation)
              response = client.public_send(#{create&.method.inspect},
                "\#{BASE_URL}\#{path}", **request_options(operation, request_method))
              handle_create_response(response)
            end

            def fetch_status(operation)
              return failure(:internal_server_error, "provider.status_operation_missing") unless #{!status.nil?}

              path = expand_path(#{status&.path.inspect}, operation)
              response = client.public_send(#{status&.method.inspect}, "\#{BASE_URL}\#{path}", **status_request_options(operation))
              handle_status_response(response)
            end

            def process_callback(payload)
              return failure(:internal_server_error, "provider.webhook_missing") unless #{!webhook.nil?}
              event = payload["event"] || payload[:event]
              return failure(:unprocessable_entity, "unknown_event") if event && !WEBHOOK_EVENTS.empty? && !WEBHOOK_EVENTS.include?(event.to_s)
              apply_status(payload)
            end

            def check_conditions(operation, request_method)
              base_result = super
              return base_result if base_result.respond_to?(:failed?) && base_result.failed?
              payload = build_payload(operation, request_method)
              #{required_fields_code(create)}
              #{conditional_conditions_code}
              constraint_error = constraint_violation(payload)
              return failure(:unprocessable_entity, constraint_error) if constraint_error
              success
            end

            private

            def build_payload(operation, request_method = nil)
              #{payload_code(create)}
            end

            def constraint_violation(payload)
              #{constraint_checks_code(create)}
              nil
            end

            def create_headers(operation)
              headers = { "Accept" => "application/json", "Content-Type" => #{(create&.content_type || "application/json").inspect} }
              #{auth_header_code(create_auth)}
              #{idempotency_header_code(create)}
              headers
            end

            def status_headers(operation)
              headers = { "Accept" => "application/json", "Content-Type" => #{(status&.content_type || "application/json").inspect} }
              #{auth_header_code(status_auth)}
              #{idempotency_header_code(status)}
              headers
            end

            def request_options(operation, request_method)
              payload = build_payload(operation, request_method)
              options = { headers: create_headers(operation) }
              options[#{request_body_key(create).inspect}] = payload
              options
            end

            def status_request_options(operation)
              options = { headers: status_headers(operation) }
              #{status_body_options_code(status)}
              options
            end

            def handle_create_response(response)
              code = response.respond_to?(:status) ? response.status.to_i : response.code.to_i
              body = response_body(response)
              return provider_failure(code, body) if code >= 400
              id = provider_id(body)
              return failure(:unprocessable_entity, "provider.operation_id_missing") if value_missing?(id)
              success(result: { id: id })
            rescue JSON::ParserError
              failure(:internal_server_error, "provider.invalid_json_response")
            end

            def handle_status_response(response)
              code = response.respond_to?(:status) ? response.status.to_i : response.code.to_i
              body = response_body(response)
              return provider_failure(code, body) if code >= 400
              apply_status(body)
            rescue JSON::ParserError
              failure(:internal_server_error, "provider.invalid_json_response")
            end

            def response_body(response)
              body = response.respond_to?(:body) ? response.body : {}
              body.is_a?(String) ? JSON.parse(body) : body
            end

            def provider_failure(code, body)
              failure(ERROR_MAP.fetch(code, "internal_server_error").to_sym, provider_error_key(body, code))
            end

            def provider_error_key(payload, http_code)
              error = payload.is_a?(Hash) ? (payload["error"] || payload[:error]) : nil
              provider_code = error.is_a?(Hash) ? (error["code"] || error[:code]) : nil
              provider_code ? "provider.\#{provider_code}" : "provider.http_\#{http_code}"
            end

            def apply_status(payload)
              status = provider_status(payload)
              mapped = STATUS_MAP.fetch(status.to_s, "unknown")
              return failure(:unprocessable_entity, "provider.unknown_status") if mapped == "unknown"

              id = provider_id(payload)
              return failure(:unprocessable_entity, "provider.operation_id_missing") if value_missing?(id)
              return approve_operation(id) if mapped == "approved"
              return reject_operation(id, provider_error_code(payload) || status.to_s) if mapped == "rejected"
              success
            end

            def provider_error_code(payload)
              return unless payload.is_a?(Hash)
              error = payload["error"] || payload[:error]
              error["code"] || error[:code] if error.is_a?(Hash)
            end

            def provider_status(payload)
              status_keys = %w[payment_state payout_status transaction_status order_status status state result_code]
              resource_payloads(payload).each do |candidate|
                status_keys.each do |wanted|
                  pair = candidate.find { |key, _| normalized_key(key) == wanted }
                  return pair.last if pair
                end
              end
              nil
            end

            def provider_id(payload)
              id_keys = %w[payment_id payout_id order_id batch_id id psp_reference]
              resource_payloads(payload).each do |candidate|
                id_keys.each do |wanted|
                  pair = candidate.find { |key, _| normalized_key(key) == wanted }
                  return pair.last if pair
                end
              end
              nil
            end

            def resource_payloads(payload)
              return [] unless payload.is_a?(Hash)
              wrappers = %w[payment payout order batch transaction data result]
              nested = payload.filter_map do |key, value|
                value if wrappers.include?(normalized_key(key)) && value.is_a?(Hash)
              end
              [payload, *nested]
            end

            def normalized_key(key)
              key.to_s.gsub(/([a-z0-9])([A-Z])/, "\\\\1_\\\\2").downcase.tr(" -", "__")
            end

            def read_operation(operation, key)
              return operation.public_send(key) if operation.respond_to?(key)
              if operation.respond_to?(:to_h)
                values = operation.to_h
                return values[key.to_sym] if values.key?(key.to_sym)
                return values[key] if values.key?(key)
              end
              nil
            end

            def read_path(operation, path)
              path.split(".").reduce(operation) do |value, key|
                break nil if value.nil?
                if value.respond_to?(key)
                  value.public_send(key)
                elsif value.respond_to?(:key?) && value.respond_to?(:[])
                  value.key?(key) ? value[key] : value[key.to_sym]
                elsif value.respond_to?(:[])
                  value[key]
                end
              end
            end

            def value_missing?(value)
              value.nil? || (value.respond_to?(:empty?) && value.empty?)
            end

            def numeric_constraint_value(value)
              BigDecimal(value.to_s)
            rescue ArgumentError, TypeError
              nil
            end

            def constraint_pattern_match?(value, pattern)
              Regexp.new(pattern).match?(value.to_s)
            rescue RegexpError
              false
            end

            def expand_path(template, operation)
              template.gsub(/\{([^}]+)\}/) do
                name = Regexp.last_match(1)
                value = if normalized_key(name).match?(/\\A(?:id|payment_(?:id|uuid)|payout_(?:id|uuid)|order_(?:id|uuid)|batch_(?:id|uuid)|transaction_(?:id|uuid))\\z/)
                          read_operation(operation, "provider_operation_key")
                        end
                value ||= read_operation(operation, name)
                raise ArgumentError, "Не заполнен path-параметр #{'#{'}name}" if value_missing?(value)
                URI.encode_www_form_component(value.to_s).gsub("+", "%20")
              end
            end

            def payout_type(operation, request_method)
              method = request_method.to_s
              return "sbp" if method == "sbp"
              return "card" if %w[card p2p].include?(method)

              requisite = read_operation(operation, "payout_requisite")
              return "sbp" if read_path(requisite, "sbp")
              return "card" unless value_missing?(read_path(requisite, "card_number"))
              nil
            end
          end
        end
      RUBY
    end

    def guide
      auth_lines = if @model.security_schemes.empty?
                     "Авторизация в спецификации не объявлена."
                   else
                     @model.security_schemes.map { |name, item| "- `#{name}`: #{item['type']}, #{item['in']} `#{item['name']}`" }.join("\n")
                   end
      operation_rows = @model.operations.map do |op|
        idem = op.parameters.any? { |param| param["name"].to_s.casecmp?("Idempotency-Key") } ? "да" : "—"
        "| `#{markdown_cell(op.id)}` | #{op.method.upcase} `#{markdown_cell(op.path)}` | #{markdown_cell(op.summary)} | #{idem} |"
      end.join("\n")
      status_rows = @model.statuses.map { |provider, internal| "| `#{provider}` | `#{internal}` |" }.join("\n")
      error_rows = @model.errors.map { |http, code| "| #{http} | `#{code}` | #{error_action(http)} |" }.join("\n")
      server_lines = if @model.servers.empty?
                       "- Адрес по умолчанию: `#{@model.base_url}`"
                     else
                       @model.servers.map do |server|
                         label = server["description"].to_s.strip
                         label = "API" if label.empty?
                         "- #{label}: `#{server['url']}`"
                       end.join("\n")
                     end
      <<~MARKDOWN
        # Руководство по интеграции #{@model.class_name}

        > Сгенерировано автоматически. Перед подключением в рабочую среду проверьте маппинг полей, контракт HTTP-клиента и подпись вебхука.

        **Результат автоматической проверки:** #{readiness_summary}

        ## Подключение

        - Базовый URL по умолчанию: `#{@model.base_url}`
        - Переменная окружения: `#{@model.env_prefix}_BASE_URL`
        - API-ключ: `#{@model.env_prefix}_API_KEY`

        Адреса из OpenAPI:

        #{server_lines}

        ## Авторизация

        #{auth_lines}

        ## Методы

        `create_request(operation, request_method = nil)` принимает операцию и логический способ выплаты. Соответствие способов выплаты полям провайдера показано ниже в таблице маппинга. Фактический HTTP-метод берётся из операции OpenAPI.

        | Операция | API-адрес | Назначение | Идемпотентность |
        |---|---|---|---|
        #{operation_rows}

        ## Обоснование выбора операций

        #{role_scores_guide}

        ## Маппинг статусов

        | Статус провайдера | Статус Space Payments |
        |---|---|
        #{status_rows.empty? ? '| — | `unknown` |' : status_rows}

        `fetch_status` и `process_callback` меняют состояние операции только через `approve_operation` / `reject_operation`. Для промежуточного статуса сервис возвращает простой `success`. Поле `status` считается основным, а `event` используется для проверки допустимого типа уведомления.

        ## Маппинг полей операции

        Гарантированные поля платформы: `operation.id`, `operation.amount` и JSONB-хеш `operation.payout_requisite`. Идентификатор провайдера для запроса статуса читается из `operation.provider_operation_key`.

        | Поле API провайдера | Источник в Space Payments |
        |---|---|
        #{field_mapping_rows(@model.create_operation)}

        ## Локальная проверка данных

        Ограничения из OpenAPI проверяются в `check_conditions` до обращения к провайдеру. При ошибке сервис возвращает `failure(:unprocessable_entity, ...)`.

        | Поле | Проверяемые ограничения |
        |---|---|
        #{constraint_rows(@model.create_operation)}

        ## Обработка ошибок

        | HTTP | Код ошибки | Рекомендуемое действие |
        |---:|---|---|
        #{error_rows}

        ## Конфигурация ProviderGateway

        #{provider_gateway_guide}

        ## Подпись webhook

        #{@model.webhook_signature || "В спецификации не обнаружена."}

        `process_callback` получает уже разобранный JSON в `payload`, без исходного тела и заголовков. Поэтому криптографическую проверку подписи нельзя корректно выполнить внутри сгенерированного сервиса: её следует делать на уровне платформы до разбора JSON. Сервис не имитирует проверку по повторно сериализованному объекту.

        ## Подтверждённые overrides

        #{overrides_guide}

        ## Предупреждения генератора

        #{@model.warnings.empty? ? "Нет." : @model.warnings.map { |warning| "- #{warning}" }.join("\n")}
      MARKDOWN
    end

    def fixtures
      create = @model.create_operation
      status = @model.status_operation
      webhook = @model.webhook_operation
      result = {
        "create_request" => {
          "request" => create&.request_example || schema_example(create&.request_schema || {}, direction: :request)
        }.merge(response_examples(create)),
        "fetch_status" => response_examples(status)
      }.merge(callback_fixtures(webhook))
      result["validation_scenarios"] = validation_scenarios(create)
      result["provider_error_scenarios"] = provider_error_scenarios(create, status)
      result["unknown_status_scenario"] = {
        "provider_response" => { "status" => 200, "body" => { "id" => "provider_test_id", "status" => "__unknown__" } },
        "expected" => { "failure" => "unprocessable_entity", "message" => "provider.unknown_status" }
      }
      result
    end

    def validation_scenarios(operation)
      return [] unless operation

      valid_payload = operation.request_example || schema_example(operation.request_schema || {}, direction: :request)
      scenarios = required_field_paths(operation.request_schema || {}).map do |path|
        validation_scenario("missing_#{snake(path)}", valid_payload, remove: path,
                            message: "missing_#{path.tr('.', '_')}")
      end

      schema_leaf_fields(operation.request_schema || {}).each do |path, schema|
        next unless schema.is_a?(Hash)

        if schema.key?("minimum")
          scenarios << validation_scenario("#{snake(path)}_below_minimum", valid_payload,
                                           set: { path => below(schema.fetch("minimum")) },
                                           message: "#{snake(path)}_below_minimum")
        end
        if schema.key?("maximum")
          scenarios << validation_scenario("#{snake(path)}_above_maximum", valid_payload,
                                           set: { path => above(schema.fetch("maximum")) },
                                           message: "#{snake(path)}_above_maximum")
        end
        if schema["pattern"] && (invalid = invalid_pattern_value(schema["pattern"]))
          scenarios << validation_scenario("#{snake(path)}_invalid_format", valid_payload,
                                           set: { path => invalid }, message: "#{snake(path)}_invalid_format")
        end
        unless Array(schema["enum"]).empty?
          scenarios << validation_scenario("#{snake(path)}_not_allowed", valid_payload,
                                           set: { path => "__not_allowed__" }, message: "#{snake(path)}_not_allowed")
        end
        if schema["minLength"].to_i.positive?
          scenarios << validation_scenario("#{snake(path)}_too_short", valid_payload,
                                           set: { path => "x" * [schema["minLength"].to_i - 1, 0].max },
                                           message: "#{snake(path)}_too_short")
        end
        if schema.key?("maxLength") && schema["maxLength"].to_i.between?(0, 256)
          scenarios << validation_scenario("#{snake(path)}_too_long", valid_payload,
                                           set: { path => "x" * (schema["maxLength"].to_i + 1) },
                                           message: "#{snake(path)}_too_long")
        end
      end

      conditional_validation_scenarios(valid_payload).each { |scenario| scenarios << scenario }
      scenarios.compact.uniq { |scenario| scenario["name"] }
    end

    def validation_scenario(name, valid_payload, remove: nil, set: nil, message:)
      mutation = {}
      mutation["remove"] = remove if remove
      mutation["set"] = set if set
      {
        "name" => name,
        "valid_request" => deep_copy(valid_payload || {}),
        "mutation" => mutation,
        "expected" => { "failure" => "unprocessable_entity", "message" => message, "http_calls" => 0 }
      }
    end

    def conditional_validation_scenarios(valid_payload)
      Array(@model.overrides["required_if"]).map do |rule|
        validation_scenario(
          "missing_#{snake(rule.fetch('field'))}_when_#{snake(rule.fetch('when'))}_is_#{snake(rule.fetch('equals').to_s)}",
          valid_payload,
          remove: rule.fetch("field"),
          set: { rule.fetch("when") => rule.fetch("equals") },
          message: "missing_#{rule.fetch('field').tr('.', '_')}"
        )
      end
    end

    def provider_error_scenarios(*operations)
      operations.compact.flat_map do |operation|
        operation.responses.filter_map do |code, _response|
          next unless code.to_s.match?(/\A[45]\d\d\z/)

          {
            "name" => "#{snake(operation.id)}_http_#{code}",
            "operation" => operation.equal?(@model.create_operation) ? "create_request" : "fetch_status",
            "fixture" => "response_#{code}",
            "expected" => { "failure" => @model.errors.fetch(code.to_i, "internal_server_error") }
          }
        end
      end
    end

    def below(value)
      value.is_a?(Integer) ? value - 1 : value.to_f - 1
    end

    def above(value)
      value.is_a?(Integer) ? value + 1 : value.to_f + 1
    end

    def invalid_pattern_value(pattern)
      verbose = $VERBOSE
      $VERBOSE = nil
      regexp = Regexp.new(pattern.to_s)
      ["__invalid__", "", "not-a-match", "0"].find { |candidate| !regexp.match?(candidate) }
    rescue RegexpError
      "__invalid_pattern__"
    ensure
      $VERBOSE = verbose
    end

    def deep_copy(value)
      JSON.parse(JSON.generate(value))
    end

    def response_examples(operation)
      return {} unless operation
      operation.responses.to_h do |code, response|
        media = response.dig("content", "application/json") || {}
        success = code.to_s.match?(/\A2\d\d\z/)
        ["response_#{code}", media["example"] || schema_example(media["schema"] || {}, direction: :response, success: success)]
      end
    end

    def callback_fixtures(webhook)
      return { "callback" => { "payload" => {}, "expected_operation_status" => "unknown" } } unless webhook

      examples = webhook.request_examples
      examples = { "default" => webhook.request_example || schema_example(webhook.request_schema, direction: :request) } if examples.empty?
      examples.each_with_index.to_h do |(name, payload), index|
        key = index.zero? ? "callback" : "callback_#{snake(name)}"
        [key, { "payload" => payload, "expected_operation_status" => callback_expected_payload(payload) }]
      end
    end

    def webhook_events(webhook)
      return [] unless webhook
      from_examples = webhook.request_examples.values.filter_map do |payload|
        next unless payload.is_a?(Hash)
        payload["event"] || payload[:event]
      end
      from_schema = event_values(webhook.request_schema)
      (from_examples + from_schema).map(&:to_s).uniq
    end

    def event_values(schema, seen = {})
      return [] unless schema.is_a?(Hash)
      return [] if seen[schema.object_id]
      seen[schema.object_id] = true

      properties = schema.fetch("properties", {})
      event_schema = properties.find { |name, _| snake(name.to_s) == "event" }&.last
      direct = event_schema ? Array(event_schema["enum"] || event_schema["x-extensible-enum"]) : []
      composed = %w[allOf oneOf anyOf].flat_map do |key|
        Array(schema[key]).flat_map { |part| event_values(part, seen) }
      end
      (direct + composed).uniq
    end

    def schema_example(schema, direction: nil, success: false)
      return schema["example"] if schema.key?("example")
      return schema["enum"].first if schema["enum"]
      type = schema["type"]
      type = "object" if type.nil? && !schema_properties(schema).empty?
      case type
      when "object"
        properties = schema_properties(schema).reject do |name, child|
          (direction == :request && child["readOnly"]) ||
            (direction == :response && child["writeOnly"]) ||
            (success && snake(name.to_s) == "error")
        end
        properties.to_h { |name, child| [name, schema_example(child, direction: direction, success: success)] }
      when "array" then [schema_example(schema.fetch("items", {}), direction: direction, success: success)]
      when "integer", "number" then schema["minimum"] || 0
      when "boolean" then true
      when "string" then string_example(schema)
      else nil
      end
    end

    def string_example(schema)
      return "2026-01-01T00:00:00Z" if schema["format"] == "date-time"
      return "00000000-0000-4000-8000-000000000000" if schema["format"] == "uuid"
      "string"
    end

    def callback_expected_payload(payload)
      status = find_fixture_value(payload, %w[status state payment_status payout_status payment_state order_status])
      @model.statuses.fetch(status.to_s, "unknown")
    end

    def find_fixture_value(value, keys)
      return nil unless value.is_a?(Hash)
      value.each do |key, child|
        return child if keys.include?(snake(key.to_s))
        nested = find_fixture_value(child, keys)
        return nested unless nested.nil?
      end
      nil
    end

    def required_fields_code(operation)
      conditional = Array(@model.overrides["required_if"]).map { |rule| rule["field"] }
      paths = required_field_paths(operation&.request_schema || {}).reject { |path| conditional.include?(path) }
      return "# В OpenAPI нет обязательных полей запроса." if paths.empty?

      paths.map do |path|
        "return failure(:unprocessable_entity, #{("missing_" + path.tr(".", "_")).inspect}) if value_missing?(read_path(payload, #{path.inspect}))"
      end.join("\n      ")
    end

    def required_field_paths(schema, prefix = nil, seen = {})
      return [] unless schema.is_a?(Hash)
      return [] if seen[schema.object_id]
      branch_seen = seen.merge(schema.object_id => true)

      properties = schema.fetch("properties", {})
      direct = Array(schema["required"]).flat_map do |name|
        path = [prefix, name].compact.join(".")
        [path] + required_field_paths(properties[name] || {}, path, branch_seen)
      end
      # allOf accumulates requirements. oneOf/anyOf describe alternatives and
      # cannot safely be flattened into a single list of mandatory fields.
      composed = Array(schema["allOf"]).flat_map do |part|
        required_field_paths(part, prefix, branch_seen)
      end
      (direct + composed).uniq
    end

    def conditional_conditions_code
      rules = Array(@model.overrides["required_if"])
      return "# Подтверждённых условно обязательных полей нет." if rules.empty?

      rules.map do |rule|
        condition = "read_path(payload, #{rule.fetch('when').inspect}).to_s == #{rule.fetch('equals').to_s.inspect}"
        "return failure(:unprocessable_entity, #{("missing_" + rule.fetch("field").tr(".", "_")).inspect}) if #{condition} && value_missing?(read_path(payload, #{rule.fetch('field').inspect}))"
      end.join("\n      ")
    end

    def constraint_checks_code(operation)
      checks = schema_leaf_fields(operation&.request_schema || {}).flat_map do |path, schema|
        next [] unless schema.is_a?(Hash)

        value = "read_path(payload, #{path.inspect})"
        key = snake(path)
        lines = []
        if schema.key?("minimum")
          limit = schema.fetch("minimum")
          lines << "number = numeric_constraint_value(#{value}); return #{"#{key}_below_minimum".inspect} if number && number < BigDecimal(#{limit.to_s.inspect})"
        end
        if schema.key?("maximum")
          limit = schema.fetch("maximum")
          lines << "number = numeric_constraint_value(#{value}); return #{"#{key}_above_maximum".inspect} if number && number > BigDecimal(#{limit.to_s.inspect})"
        end
        if schema["pattern"]
          lines << "value = #{value}; return #{"#{key}_invalid_format".inspect} if !value_missing?(value) && !constraint_pattern_match?(value, #{schema['pattern'].to_s.inspect})"
        end
        enum = Array(schema["enum"])
        unless enum.empty?
          lines << "value = #{value}; return #{"#{key}_not_allowed".inspect} if !value_missing?(value) && !#{ruby_literal(enum)}.include?(value)"
        end
        if schema.key?("minLength")
          limit = Integer(schema.fetch("minLength"))
          lines << "value = #{value}; return #{"#{key}_too_short".inspect} if !value_missing?(value) && value.to_s.length < #{limit}"
        end
        if schema.key?("maxLength")
          limit = Integer(schema.fetch("maxLength"))
          lines << "value = #{value}; return #{"#{key}_too_long".inspect} if !value_missing?(value) && value.to_s.length > #{limit}"
        end
        lines
      rescue ArgumentError, TypeError
        []
      end
      checks.empty? ? "# В OpenAPI нет ограничений полей для локальной проверки." : checks.join("\n      ")
    end

    def idempotency_header_code(operation)
      parameter = operation&.parameters&.find do |item|
        item["in"] == "header" && item["name"].to_s.match?(/idempot/i)
      end
      return "# Для операции не объявлен заголовок идемпотентности." unless parameter

      "headers[#{parameter.fetch('name').inspect}] = operation.id.to_s if operation.respond_to?(:id)"
    end

    def overrides_guide
      return "Не переданы. Элементы из свободного текста остаются TODO в предупреждениях." if @model.overrides.empty?

      lines = []
      @model.overrides.fetch("operations", {}).each do |role, selector|
        chosen = selector["operation_id"] || "#{selector['method'].to_s.upcase} #{selector['path']}"
        lines << "- Роль `#{role}` подтверждена вручную: `#{chosen}`."
      end
      lines << "- Единица суммы: `#{@model.overrides.dig('amount', 'unit')}`, множитель `#{@model.amount_multiplier}`." if @model.overrides["amount"]
      Array(@model.overrides["required_if"]).each do |rule|
        lines << "- `#{rule['field']}` обязательно, когда `#{rule['when']} = #{rule['equals']}`."
      end
      signature = @model.overrides["webhook_signature"]
      lines << "- Подпись: `#{signature['algorithm']}`, кодирование `#{signature['encoding']}`, заголовок `#{signature['header']}`; проверка выполняется платформой до разбора JSON." if signature
      lines.join("\n")
    end

    def provider_gateway_guide
      config = @model.overrides["provider_gateway"]
      return "Не задана. Укажите `provider_gateway.external_method` и `provider_gateway.gateway` в overrides после подтверждения бизнес-маршрута." unless config

      "```json\n#{JSON.pretty_generate(config)}\n```"
    end

    def readiness_summary
      return "критичных предупреждений нет; перед рабочим подключением артефакты всё равно требуют контрактного ревью." if @model.warnings.empty?
      "найдено предупреждений: #{@model.warnings.length}. Проверьте раздел «Предупреждения генератора» перед подключением."
    end

    def role_scores_guide
      @model.role_scores.map do |role, scores|
        selected = scores["selected"]
        runner_up = scores["runner_up"]
        role_name = { "create" => "создание", "status" => "проверка статуса" }.fetch(role, role)
        next "- `#{role}` (#{role_name}): кандидаты отсутствуют." unless selected

        confirmation = selected["source"] == "overrides" ? "; выбор подтверждён в overrides" : ""
        line = "- `#{role}` (#{role_name}): #{selected['method'].upcase} `#{selected['path']}` — оценка #{selected['score']}#{confirmation}"
        if runner_up
          line += "; следующий кандидат #{runner_up['method'].upcase} `#{runner_up['path']}` — " \
                  "оценка #{runner_up['score']}; разница #{scores['margin']}"
        end
        line + "."
      end.join("\n")
    end

    def payload_code(operation, request_method_expression: "request_method")
      schema = operation&.request_schema || {}
      payload_hash_code(schema, request_method_expression: request_method_expression)
    end

    def payload_hash_code(schema, prefix: nil, request_method_expression:)
      properties = schema_properties(schema)
      return "{}" if properties.empty?

      pairs = properties.map do |key, child|
        path = [prefix, key].compact.join(".")
        value = if child.is_a?(Hash) && !child.fetch("properties", {}).empty?
                  payload_hash_code(child, prefix: path, request_method_expression: request_method_expression)
                else
                  source_expression(field_source(path, child), path, request_method_expression)
                end
        "#{key.inspect} => #{value}"
      end
      "{ #{pairs.join(', ')} }.compact"
    end

    def field_source(path, schema = {})
      configured = @model.overrides.fetch("field_map", {})[path]
      return configured if configured

      return "operation.amount" if path == "amount"
      return "operation.id" if %w[external_id merchant_operation_id].include?(path)
      return "payout_type" if path == "recipient.type"
      return "payout_requisite.sbp.phone" if path == "recipient.phone"
      return "payout_requisite.sbp.bank_code" if path == "recipient.bank_code"
      return "payout_requisite.sbp.bank_name" if path == "recipient.bank_name"
      return "payout_requisite.card_number" if path == "recipient.card_number"

      enum = Array(schema["enum"])
      return "literal:#{enum.first}" if enum.one?
      return "literal:#{schema['default']}" if schema.key?("default")
      nil
    end

    def source_expression(source, path, request_method_expression)
      return "nil" unless source
      if source.start_with?("operation.")
        expression = "read_operation(operation, #{source.delete_prefix('operation.').inspect})"
        return "(BigDecimal(#{expression}.to_s) * #{@model.amount_multiplier}).to_i" if path.split(".").last == "amount" && @model.amount_multiplier != 1
        return expression
      end
      if source.start_with?("payout_requisite.")
        requisite_path = source.delete_prefix("payout_requisite.")
        return "read_path(read_operation(operation, \"payout_requisite\"), #{requisite_path.inspect})"
      end
      return "payout_type(operation, #{request_method_expression})" if source == "payout_type"
      return request_method_expression if source == "request_method"
      return source.delete_prefix("literal:").inspect if source.start_with?("literal:")
      "nil"
    end

    def field_mapping_rows(operation)
      leaves = schema_leaf_fields(operation&.request_schema || {})
      return "| — | TODO: в операции нет полей запроса |" if leaves.empty?

      leaves.map do |path, schema|
        source = field_source(path, schema)
        label = source ? "`#{source}`" : "**TODO:** подтвердить схему платформы"
        "| `#{path}` | #{label} |"
      end.join("\n")
    end

    def constraint_rows(operation)
      rows = schema_leaf_fields(operation&.request_schema || {}).filter_map do |path, schema|
        values = []
        values << "minimum: `#{schema['minimum']}`" if schema.key?("minimum")
        values << "maximum: `#{schema['maximum']}`" if schema.key?("maximum")
        values << "pattern: `#{markdown_cell(schema['pattern'])}`" if schema["pattern"]
        values << "enum: `#{Array(schema['enum']).join(', ')}`" unless Array(schema["enum"]).empty?
        values << "minLength: `#{schema['minLength']}`" if schema.key?("minLength")
        values << "maxLength: `#{schema['maxLength']}`" if schema.key?("maxLength")
        "| `#{path}` | #{values.join('; ')} |" unless values.empty?
      end
      rows.empty? ? "| — | В OpenAPI не объявлены |" : rows.join("\n")
    end

    def schema_leaf_fields(schema, prefix = nil)
      schema_properties(schema).flat_map do |key, child|
        path = [prefix, key].compact.join(".")
        nested = child.is_a?(Hash) ? schema_properties(child) : {}
        nested.empty? ? [[path, child || {}]] : schema_leaf_fields(child, path)
      end
    end

    def schema_properties(schema, seen = {})
      return {} unless schema.is_a?(Hash)
      return {} if seen[schema.object_id]

      branch_seen = seen.merge(schema.object_id => true)
      composed = Array(schema["allOf"]).each_with_object({}) do |part, result|
        result.merge!(schema_properties(part, branch_seen))
      end
      composed.merge(schema.fetch("properties", {}))
    end

    def auth_header_code(auth)
      return "# Авторизация в спецификации не объявлена." if auth.empty?
      return "headers[#{auth['name'].inspect}] = ENV.fetch(\"#{@model.env_prefix}_API_KEY\")" if auth["type"] == "apiKey" && auth["in"] == "header"
      if auth["type"] == "http" && auth["scheme"].to_s.casecmp?("basic")
        return "credentials = [ENV.fetch(\"#{@model.env_prefix}_USERNAME\"), ENV.fetch(\"#{@model.env_prefix}_PASSWORD\")].join(\":\")\n      headers[\"Authorization\"] = \"Basic \#{Base64.strict_encode64(credentials)}\""
      end
      if auth["type"] == "http" && auth["scheme"].to_s.casecmp?("bearer")
        return "headers[\"Authorization\"] = \"Bearer \#{ENV.fetch(\"#{@model.env_prefix}_ACCESS_TOKEN\")}\""
      end
      "# TODO: реализуйте авторизацию типа #{auth['type']}."
    end

    def auth_for(operation)
      names = Array(operation&.security).flat_map(&:keys)
      name = names.find do |candidate|
        scheme = @model.security_schemes[candidate]
        scheme && supported_auth?(scheme)
      end
      name ||= names.find { |candidate| @model.security_schemes.key?(candidate) }
      name ? @model.security_schemes.fetch(name) : {}
    end

    def supported_auth?(auth)
      (auth["type"] == "apiKey" && auth["in"] == "header") ||
        (auth["type"] == "http" && %w[basic bearer].include?(auth["scheme"].to_s.downcase))
    end

    def request_body_key(operation)
      operation&.content_type == "application/json" ? :json : :form
    end

    def status_body_options_code(operation)
      return "# У GET-операции проверки статуса нет тела запроса." if operation.nil? || operation.method == "get" || operation.request_schema.empty?
      "options[#{request_body_key(operation).inspect}] = #{payload_code(operation, request_method_expression: 'nil')}"
    end

    def ruby_literal(value)
      value.inspect
    end

    def markdown_cell(value)
      value.to_s.gsub("|", "\\|").gsub(/\r?\n/, "<br>")
    end

    def error_action(http)
      return "исправить учётные данные и уведомить сопровождение" if http == 401
      return "повторить с увеличивающейся задержкой" if http == 429 || http >= 500
      return "повторить позже" if http == 402
      "не повторять автоматически"
    end

    def snake(value)
      value.gsub(/([a-z\d])([A-Z])/, "\\1_\\2").gsub(/[^a-zA-Z0-9]+/, "_").downcase.sub(/^_/, "").sub(/_$/, "")
    end
  end
end
