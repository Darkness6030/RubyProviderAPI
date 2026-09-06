# frozen_string_literal: true

require "yaml"

module ProviderGenerator
  class OverrideConfig
    ALLOWED_KEYS = %w[version amount field_map required_if webhook_signature status_map error_map provider_gateway].freeze

    class << self
      def load(path)
        return {} unless path
        raise Error, "Файл overrides не найден: #{path}" unless File.file?(path)

        data = YAML.safe_load(File.read(path, encoding: "UTF-8"), aliases: false) || {}
        raise Error, "Корневое значение overrides должно быть YAML-объектом." unless data.is_a?(Hash)

        unknown = data.keys.map(&:to_s) - ALLOWED_KEYS
        raise Error, "Неизвестные ключи overrides: #{unknown.join(', ')}" unless unknown.empty?
        raise Error, "Версия overrides должна быть равна 1." unless data.fetch("version", 1) == 1

        validate_required_if(data["required_if"])
        validate_amount(data["amount"])
        validate_field_map(data["field_map"])
        validate_status_map(data["status_map"])
        validate_error_map(data["error_map"])
        validate_provider_gateway(data["provider_gateway"])
        data
      rescue Psych::Exception => e
        raise Error, "Некорректный файл overrides: #{e.message}"
      end

      private

      def validate_required_if(rules)
        Array(rules).each_with_index do |rule, index|
          required = %w[field when equals]
          missing = required.reject { |key| rule.is_a?(Hash) && rule.key?(key) }
          raise Error, "В required_if[#{index}] отсутствуют поля: #{missing.join(', ')}" unless missing.empty?
        end
      end

      def validate_amount(amount)
        return unless amount
        raise Error, "amount должен быть YAML-объектом." unless amount.is_a?(Hash)
        multiplier = Integer(amount["multiplier"])
        raise Error, "Множитель amount.multiplier должен быть положительным." unless multiplier.positive?
      rescue KeyError, ArgumentError, TypeError
        raise Error, "amount.multiplier должен быть положительным целым числом."
      end

      def validate_field_map(field_map)
        return unless field_map
        raise Error, "field_map должен быть YAML-объектом." unless field_map.is_a?(Hash)

        invalid = field_map.reject do |path, source|
          !path.to_s.empty? && source.is_a?(String) &&
            source.match?(/\A(?:operation\.(?:id|amount|status|provider_operation_key|gateway)|request_method|payout_type|payout_requisite(?:\.[A-Za-z0-9_]+)+|literal:.+)\z/)
        end
        return if invalid.empty?

        raise Error, "Недопустимые источники в field_map: #{invalid.map { |path, source| "#{path}=#{source.inspect}" }.join(', ')}"
      end

      def validate_status_map(status_map)
        return unless status_map
        raise Error, "status_map должен быть YAML-объектом." unless status_map.is_a?(Hash)
        allowed = %w[in_progress approved rejected unknown]
        invalid = status_map.reject { |_, value| allowed.include?(value.to_s) }
        return if invalid.empty?
        raise Error, "Недопустимые внутренние статусы в status_map: #{invalid.values.uniq.join(', ')}"
      end

      def validate_error_map(error_map)
        return unless error_map
        raise Error, "error_map должен быть YAML-объектом." unless error_map.is_a?(Hash)
        allowed = %w[bad_request unauthorized forbidden unprocessable_entity too_many_requests internal_server_error]
        invalid = error_map.reject do |http, code|
          http.to_s.match?(/\A[45]\d\d\z/) && allowed.include?(code.to_s)
        end
        return if invalid.empty?

        raise Error, "error_map принимает только HTTP-коды и подтверждённые коды failure: #{invalid.inspect}"
      end

      def validate_provider_gateway(config)
        return unless config
        missing = %w[external_method gateway].reject { |key| config.is_a?(Hash) && !config[key].to_s.empty? }
        raise Error, "В provider_gateway отсутствуют поля: #{missing.join(', ')}" unless missing.empty?
      end
    end
  end
end
