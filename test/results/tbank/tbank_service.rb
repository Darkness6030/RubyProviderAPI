# frozen_string_literal: true
# Сгенерировано из Прием платежей. Перед production-использованием проверьте маппинг полей.

require "json"
require "base64"
require "bigdecimal"
require "uri"

class Provider
  class TbankService < BaseService
    BASE_URL = ENV.fetch("TBANK_BASE_URL", "https://securepay.tinkoff.ru")
    STATUS_MAP = {"NEW" => "in_progress", "AUTHORIZED" => "approved", "CONFIRMED" => "approved", "REVERSED" => "rejected", "REFUNDED" => "rejected", "PARTIAL_REFUNDED" => "rejected", "REJECTED" => "rejected", "DEADLINE_EXPIRED" => "rejected", "3DS_CHECKING" => "in_progress", "3DS_CHECKED" => "in_progress", "FORM_SHOWED" => "in_progress"}.freeze
    ERROR_MAP = {500 => "internal_server_error"}.freeze
    WEBHOOK_EVENTS = [].freeze

    def create_request(operation, request_method = nil)
      return failure(:internal_server_error, "provider.create_operation_missing") unless true

      path = expand_path("/v2/Init", operation)
      response = client.public_send("post",
        "#{BASE_URL}#{path}", **request_options(operation, request_method))
      handle_create_response(response)
    end

    def fetch_status(operation)
      return failure(:internal_server_error, "provider.status_operation_missing") unless true

      path = expand_path("/v2/GetState", operation)
      response = client.public_send("post", "#{BASE_URL}#{path}", **status_request_options(operation))
      handle_status_response(response)
    end

    def process_callback(payload)
      return failure(:internal_server_error, "provider.webhook_missing") unless false
      event = payload["event"] || payload[:event]
      return failure(:unprocessable_entity, "unknown_event") if event && !WEBHOOK_EVENTS.empty? && !WEBHOOK_EVENTS.include?(event.to_s)
      apply_status(payload)
    end

    def check_conditions(operation, request_method)
      base_result = super
      return base_result if base_result.respond_to?(:failed?) && base_result.failed?
      payload = build_payload(operation, request_method)
      return failure(:unprocessable_entity, "missing_TerminalKey") if value_missing?(read_path(payload, "TerminalKey"))
      return failure(:unprocessable_entity, "missing_Token") if value_missing?(read_path(payload, "Token"))
      return failure(:unprocessable_entity, "missing_Amount") if value_missing?(read_path(payload, "Amount"))
      return failure(:unprocessable_entity, "missing_OrderId") if value_missing?(read_path(payload, "OrderId"))
      # Подтверждённых условно обязательных полей нет.
      constraint_error = constraint_violation(payload)
      return failure(:unprocessable_entity, constraint_error) if constraint_error
      success
    end

    private

    def build_payload(operation, request_method = nil)
      { "TerminalKey" => nil, "Amount" => nil, "OrderId" => nil, "Token" => nil, "Description" => nil, "CustomerKey" => nil, "Recurrent" => "Y", "PayType" => nil, "Language" => "ru", "NotificationURL" => nil, "SuccessURL" => nil, "FailURL" => nil, "RedirectDueDate" => nil, "DATA" => nil, "Receipt" => nil, "Shops" => nil }.compact
    end

    def constraint_violation(payload)
      value = read_path(payload, "TerminalKey"); return "terminal_key_too_long" if !value_missing?(value) && value.to_s.length > 64
      value = read_path(payload, "OrderId"); return "order_id_too_long" if !value_missing?(value) && value.to_s.length > 50
      value = read_path(payload, "Description"); return "description_too_long" if !value_missing?(value) && value.to_s.length > 140
      value = read_path(payload, "CustomerKey"); return "customer_key_too_long" if !value_missing?(value) && value.to_s.length > 255
      value = read_path(payload, "Recurrent"); return "recurrent_not_allowed" if !value_missing?(value) && !["Y"].include?(value)
      value = read_path(payload, "Recurrent"); return "recurrent_too_long" if !value_missing?(value) && value.to_s.length > 1
      value = read_path(payload, "PayType"); return "pay_type_not_allowed" if !value_missing?(value) && !["O", "T"].include?(value)
      value = read_path(payload, "Language"); return "language_too_long" if !value_missing?(value) && value.to_s.length > 2
      nil
    end

    def create_headers(operation)
      headers = { "Accept" => "application/json", "Content-Type" => "application/json" }
      # Авторизация в спецификации не объявлена.
      # Для операции не объявлен заголовок идемпотентности.
      headers
    end

    def status_headers(operation)
      headers = { "Accept" => "application/json", "Content-Type" => "application/json" }
      # Авторизация в спецификации не объявлена.
      # Для операции не объявлен заголовок идемпотентности.
      headers
    end

    def request_options(operation, request_method)
      payload = build_payload(operation, request_method)
      options = { headers: create_headers(operation) }
      options[:json] = payload
      options
    end

    def status_request_options(operation)
      options = { headers: status_headers(operation) }
      options[:json] = { "TerminalKey" => nil, "PaymentId" => nil, "Token" => nil, "IP" => nil, "GetPhone" => nil }.compact
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
      provider_code ? "provider.#{provider_code}" : "provider.http_#{http_code}"
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
      key.to_s.gsub(/([a-z0-9])([A-Z])/, "\\1_\\2").downcase.tr(" -", "__")
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
      template.gsub(/{([^}]+)}/) do
        name = Regexp.last_match(1)
        value = if normalized_key(name).match?(/\A(?:id|payment_(?:id|uuid)|payout_(?:id|uuid)|order_(?:id|uuid)|batch_(?:id|uuid)|transaction_(?:id|uuid))\z/)
                  read_operation(operation, "provider_operation_key")
                end
        value ||= read_operation(operation, name)
        raise ArgumentError, "Не заполнен path-параметр #{name}" if value_missing?(value)
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
