# frozen_string_literal: true

require "json"
require "open3"
require "rbconfig"
require "tmpdir"

module ProviderGenerator
  # Проверяет уже сгенерированный пакет без сетевых запросов и внешних gem.
  class Verifier
    CONTRACT_SCRIPT = <<~'RUBY'
      class BaseService
        def success(**value) = { success: value }
        def failure(code, message) = { failure: code, message: message }
        def check_conditions(*) = success
        def approve_operation(id) = { approved: id }
        def reject_operation(id, reason) = { rejected: id, reason: reason }
      end

      load ARGV.fetch(0)
      klass = Provider.const_get("#{ARGV.fetch(1)}Service")
      required = %i[create_request fetch_status process_callback check_conditions]
      missing = required.reject { |method| klass.public_instance_methods.include?(method) }
      abort("Нет методов: #{missing.join(', ')}") unless missing.empty?
    RUBY

    BEHAVIOR_SCRIPT = <<~'RUBY'
      require "json"
      require "ostruct"

      class BaseService
        def success(**value) = { success: value }
        def failure(code, message) = { failure: code, message: message }
        def check_conditions(*) = success
        def approve_operation(id) = { approved: id }
        def reject_operation(id, reason) = { rejected: id, reason: reason }
      end

      Response = Struct.new(:status, :body)
      class FakeClient
        attr_reader :calls

        def initialize(status, body)
          @status = status
          @body = body
          @calls = []
        end

        def method_missing(method, *args, **options)
          @calls << { method: method, args: args, options: options }
          Response.new(@status, @body)
        end

        def respond_to_missing?(*); true; end
      end

      service_path, fixtures_path, config_json = ARGV
      config = JSON.parse(config_json)
      fixtures = JSON.parse(File.read(fixtures_path))
      prefix = config.fetch("env_prefix")
      ENV["#{prefix}_API_KEY"] = "verification-key"
      ENV["#{prefix}_USERNAME"] = "verification-user"
      ENV["#{prefix}_PASSWORD"] = "verification-password"
      ENV["#{prefix}_ACCESS_TOKEN"] = "verification-token"

      load service_path
      klass = Provider.const_get("#{config.fetch('class_name')}Service")
      response_key, response_body = fixtures.fetch("create_request", {}).find { |key, _| key.match?(/\Aresponse_2\d\d\z/) }
      abort("Нет успешной фикстуры create_request") unless response_key

      client = FakeClient.new(response_key.delete_prefix("response_").to_i, response_body)
      service = klass.allocate
      service.define_singleton_method(:client) { client }
      operation = OpenStruct.new(
        id: "operation_verification",
        amount: config.fetch("valid_amount"),
        payout_requisite: {
          "sbp" => { "phone" => "79001234567", "bank_code" => "044525225", "bank_name" => "Банк" },
          "card_number" => "4111111111111111"
        },
        provider_operation_key: "provider_verification"
      )

      condition = service.check_conditions(operation, "sbp")
      abort("Корректная операция не прошла check_conditions: #{condition.inspect}") if condition[:failure]
      result = service.create_request(operation, "sbp")
      abort("create_request не вернул result.id: #{result.inspect}") unless result.dig(:success, :result, :id)
      abort("Ожидался ровно один HTTP-вызов") unless client.calls.length == 1

      if config["invalid_amount"]
        invalid = operation.dup
        invalid.amount = config.fetch("invalid_amount")
        rejected = service.check_conditions(invalid, "sbp")
        abort("Сумма вне minimum не отклонена: #{rejected.inspect}") unless rejected[:failure] == :unprocessable_entity
        abort("Локальная проверка выполнила HTTP-вызов") unless client.calls.length == 1
      end
    RUBY

    def initialize(model, files:, output:, documentation_output: output)
      @model = model
      @files = files
      @output = output
      @documentation_output = documentation_output
      @checks = []
    end

    def call
      check_required_files
      check_ruby_syntax
      check_fixtures
      check_contract
      check_behavior
      check_determinism
      { passed: @checks.all? { |check| check[:passed] }, checks: @checks }
    end

    private

    def record(name, passed, detail)
      @checks << { name: name, passed: passed, detail: detail }
    end

    def service_path
      @files.find { |path| File.basename(path) == "#{snake(@model.provider)}_service.rb" }
    end

    def fixtures_path
      @files.find { |path| File.basename(path) == "fixtures.json" }
    end

    def check_required_files
      expected = ["#{snake(@model.provider)}_service.rb", "INTEGRATION.md", "fixtures.json"]
      found = @files.select { |path| File.file?(path) }.map { |path| File.basename(path) }
      missing = expected - found
      record("файлы", missing.empty?, missing.empty? ? "3 из 3 на месте" : "нет: #{missing.join(', ')}")
    end

    def check_ruby_syntax
      return record("синтаксис Ruby", false, "файл сервиса не найден") unless service_path

      output, error, status = Open3.capture3(RbConfig.ruby, "-c", service_path.to_s)
      record("синтаксис Ruby", status.success?, status.success? ? output.strip : error.strip)
    rescue SystemCallError => e
      record("синтаксис Ruby", false, e.message)
    end

    def check_fixtures
      fixtures = JSON.parse(File.read(fixtures_path, encoding: "UTF-8"))
      negative = Array(fixtures["validation_scenarios"])
      provider_errors = Array(fixtures["provider_error_scenarios"])
      passed = fixtures["create_request"].is_a?(Hash) && fixtures.key?("validation_scenarios") &&
               fixtures.key?("provider_error_scenarios")
      record("фикстуры", passed, "#{negative.length} локальных ошибок, #{provider_errors.length} HTTP-ошибок")
    rescue JSON::ParserError, SystemCallError, TypeError => e
      record("фикстуры", false, e.message)
    end

    def check_contract
      return record("контракт сервиса", false, "файл сервиса не найден") unless service_path

      _output, error, status = Open3.capture3(RbConfig.ruby, "-e", CONTRACT_SCRIPT, service_path.to_s, @model.class_name)
      record("контракт сервиса", status.success?, status.success? ? "класс загружается, методы доступны" : error.strip)
    rescue SystemCallError => e
      record("контракт сервиса", false, e.message)
    end

    def check_behavior
      unless service_path && fixtures_path
        return record("сценарий без сети", false, "сервис или фикстуры не найдены")
      end

      config = behavior_config
      _output, error, status = Open3.capture3(
        RbConfig.ruby, "-e", BEHAVIOR_SCRIPT,
        service_path.to_s, fixtures_path.to_s, JSON.generate(config)
      )
      record("сценарий без сети", status.success?, status.success? ? "создание и локальная проверка пройдены" : error.strip)
    rescue SystemCallError, JSON::ParserError => e
      record("сценарий без сети", false, e.message)
    end

    def behavior_config
      amount_schema = schema_field(@model.create_operation&.request_schema || {}, "amount") || {}
      minimum = amount_schema["minimum"]
      multiplier = @model.amount_multiplier.to_f
      valid_amount = minimum ? (minimum.to_f / multiplier) + 1 : 1_500
      invalid_amount = minimum ? (minimum.to_f - 1) / multiplier : nil
      {
        class_name: @model.class_name,
        env_prefix: @model.env_prefix,
        valid_amount: integral(valid_amount),
        invalid_amount: invalid_amount && integral(invalid_amount)
      }
    end

    def schema_field(schema, path)
      path.split(".").reduce(schema) do |node, key|
        break unless node.is_a?(Hash)
        node.fetch("properties", {})[key]
      end
    end

    def integral(value)
      value.to_i == value ? value.to_i : value
    end

    def check_determinism
      identical = Dir.mktmpdir("provider-generator-verification") do |directory|
        regenerated = Generator.new(@model, output: directory, documentation_output: directory).call
        originals = @files.to_h { |path| [File.basename(path), path] }
        copies = regenerated.to_h { |path| [File.basename(path), path] }
        originals.keys.sort == copies.keys.sort && originals.all? do |name, path|
          File.binread(path) == File.binread(copies.fetch(name))
        end
      end
      record("повторяемость", identical, identical ? "повторная генерация побайтово совпала" : "файлы различаются")
    rescue SystemCallError, Error => e
      record("повторяемость", false, e.message)
    end

    def snake(value)
      value.gsub(/([a-z\d])([A-Z])/, "\\1_\\2").gsub(/[^a-zA-Z0-9]+/, "_").downcase.sub(/^_/, "").sub(/_$/, "")
    end
  end
end
