# frozen_string_literal: true

require "minitest/autorun"
require "tmpdir"
require "ostruct"
require "provider_generator"

class GeneratorTest < Minitest::Test
  def test_generates_every_supported_schema_constraint
    spec = ProviderGenerator::SpecLoader.load(File.expand_path("../examples/novapay/openapi.yaml", __dir__))
    schema = spec.dig("paths", "/payouts", "post", "requestBody", "content", "application/json", "schema")
    schema.dig("properties", "amount")["maximum"] = 200_000
    schema.dig("properties", "external_id")["minLength"] = 3
    overrides = ProviderGenerator::OverrideConfig.load(File.expand_path("../examples/novapay/overrides.yaml", __dir__))
    model = ProviderGenerator::Analyzer.new(spec, provider: "novapay", overrides: overrides).call

    Dir.mktmpdir do |directory|
      ProviderGenerator::Generator.new(model, output: directory).call
      service = File.read(File.join(directory, "novapay_service.rb"))
      fixtures = JSON.parse(File.read(File.join(directory, "fixtures.json")))
      names = fixtures.fetch("validation_scenarios").map { |scenario| scenario.fetch("name") }

      assert_includes service, 'return "amount_above_maximum"'
      assert_includes service, 'return "external_id_too_short"'
      assert_includes names, "amount_above_maximum"
      assert_includes names, "external_id_too_short"
    end
  end

  def test_generates_expected_files
    spec = ProviderGenerator::SpecLoader.load(File.expand_path("../examples/novapay/openapi.yaml", __dir__))
    overrides = ProviderGenerator::OverrideConfig.load(File.expand_path("../examples/novapay/overrides.yaml", __dir__))
    model = ProviderGenerator::Analyzer.new(spec, provider: "novapay", overrides: overrides).call
    Dir.mktmpdir do |directory|
      files = ProviderGenerator::Generator.new(model, output: directory).call
      assert_equal 3, files.length
      files.each { |file| assert File.file?(file) }
      assert_includes File.read(File.join(directory, "novapay_service.rb")), "class NovapayService"
      service = File.read(File.join(directory, "novapay_service.rb"))
      guide = File.read(File.join(directory, "INTEGRATION.md"))
      assert_includes service, "def create_request(operation, request_method = nil)"
      refute_includes service, "raw_body"
      refute_includes service, "verify_signature!"
      assert_includes service, 'BigDecimal(read_operation(operation, "amount").to_s) * 100'
      assert_includes service, 'read_path(read_operation(operation, "payout_requisite"), "sbp.phone")'
      assert_includes service, 'read_path(read_operation(operation, "payout_requisite"), "card_number")'
      assert_includes service, "def constraint_violation(payload)"
      assert_includes service, 'return "amount_below_minimum"'
      assert_includes service, 'return "recipient_phone_invalid_format"'
      assert_includes service, 'return "external_id_too_long"'
      assert_includes service, 'WEBHOOK_EVENTS = ["payout.completed", "payout.failed", "payout.processing", "payout.cancelled"]'
      assert_includes service, "payment_state payout_status transaction_status order_status status state result_code"
      assert_includes service, "resource_payloads(payload)"
      assert_includes service, 'gsub(/([a-z0-9])([A-Z])/, "\\\\1_\\\\2")'
      assert_includes service, '"missing_amount"'
      assert_includes service, '"missing_currency"'
      assert_includes service, '"missing_external_id"'
      assert_includes service, '"missing_recipient_phone"'
      assert_includes service, '"missing_recipient_bank_code"'
      assert_includes guide, "логический способ выплаты"
      refute_includes guide, "Для NovaPay"
      assert_includes guide, "Sandbox: `https://api.sandbox.novapay.example/v1`"
      assert_includes guide, "Production: `https://api.novapay.example/v1`"
      assert_includes guide, "operation.provider_operation_key"
      assert_includes guide, "проверку подписи нельзя корректно выполнить внутри"
      assert_includes guide, "Обоснование выбора операций"
      assert_includes guide, "разница"
      fixtures = JSON.parse(File.read(File.join(directory, "fixtures.json")))
      assert fixtures.dig("create_request", "response_201")
      assert_equal "approved", fixtures.dig("callback", "expected_operation_status")
      assert_equal "rejected", fixtures.dig("callback_failed", "expected_operation_status")
      refute fixtures.dig("fetch_status", "response_200").key?("error")
      validation_names = fixtures.fetch("validation_scenarios").map { |scenario| scenario.fetch("name") }
      assert_includes validation_names, "amount_below_minimum"
      assert_includes validation_names, "recipient_phone_invalid_format"
      assert_includes validation_names, "external_id_too_long"
      assert fixtures.fetch("provider_error_scenarios").any? { |scenario| scenario["name"].end_with?("http_429") }
      assert_equal "provider.unknown_status", fixtures.dig("unknown_status_scenario", "expected", "message")
      assert_includes guide, "RUB_SBP_WITHDRAW"
      assert_includes guide, "критичных предупреждений нет"
      assert_includes guide, "выбор подтверждён в overrides"
      assert_includes guide, "Локальная проверка данных"

      Object.const_set(:BaseService, Class.new do
        def success(**value) = { success: value }
        def failure(code, message) = { failure: code, message: message }
        def check_conditions(*) = success
        def approve_operation(id) = { approved: id }
        def reject_operation(id, reason) = { rejected: id, reason: reason }
      end)
      load File.join(directory, "novapay_service.rb")
      service_instance = Provider::NovapayService.allocate
      assert_equal "COMPLETED", service_instance.send(:provider_status, "payment" => { "status" => "COMPLETED" })
      assert_equal "AWAITING_FUNDING", service_instance.send(:provider_status, "paymentState" => "AWAITING_FUNDING")
      assert_equal "pay_123", service_instance.send(:provider_id, "payment" => { "id" => "pay_123" })
      operation = Struct.new(:provider_operation_key).new("np 123")
      assert_equal "/payouts/np%20123", service_instance.send(:expand_path, "/payouts/{payout_id}", operation)
      response = Struct.new(:status, :body).new(200, { "id" => "np_1", "status" => "unexpected" })
      assert_equal :unprocessable_entity, service_instance.send(:handle_status_response, response)[:failure]
      invalid_response = Struct.new(:status, :body).new(200, "not-json")
      assert_equal :internal_server_error, service_instance.send(:handle_create_response, invalid_response)[:failure]

      fake_client = Class.new do
        attr_reader :url, :options
        def post(url, **options)
          @url = url
          @options = options
          Struct.new(:status, :body).new(201, { "id" => "np_2", "status" => "pending" })
        end

        def get(url, **options)
          @url = url
          @options = options
          Struct.new(:status, :body).new(200, { "id" => "np_2", "status" => "completed" })
        end
      end.new
      service_instance.define_singleton_method(:client) { fake_client }
      payment = OpenStruct.new(id: "op_1", amount: 1_500,
                               payout_requisite: { "sbp" => { "phone" => "79001234567", "bank_code" => "044525225", "bank_name" => "Сбербанк" } },
                               provider_operation_key: nil)
      previous_api_key = ENV["NOVAPAY_API_KEY"]
      ENV["NOVAPAY_API_KEY"] = "test-key"
      result = service_instance.create_request(payment, :sbp)
      assert_equal "https://api.sandbox.novapay.example/v1/payouts", fake_client.url
      assert_equal 150_000, fake_client.options.dig(:json, "amount")
      assert_equal "test-key", fake_client.options.dig(:headers, "X-API-Key")
      assert_equal "np_2", result.dig(:success, :result, :id)

      status_operation = OpenStruct.new(provider_operation_key: "np 2")
      status_result = service_instance.fetch_status(status_operation)
      assert_equal "https://api.sandbox.novapay.example/v1/payouts/np%202", fake_client.url
      assert_equal "test-key", fake_client.options.dig(:headers, "X-API-Key")
      assert_equal "np_2", status_result[:approved]
      refute fake_client.options.dig(:headers).key?("Idempotency-Key")

      missing_phone = OpenStruct.new(id: "op_2", amount: 1_500,
                                     payout_requisite: { "sbp" => { "bank_code" => "044525225" } })
      assert_equal :unprocessable_entity, service_instance.check_conditions(missing_phone, "create")[:failure]
      assert_equal "missing_recipient_phone", service_instance.check_conditions(missing_phone, "create")[:message]

      valid_operation = OpenStruct.new(id: "op_3", amount: 1_500,
                                       payout_requisite: { "sbp" => { "phone" => "79001234567", "bank_code" => "044525225" } })
      assert service_instance.check_conditions(valid_operation, "create").key?(:success)

      low_amount = OpenStruct.new(id: "op_3", amount: 999,
                                  payout_requisite: { "sbp" => { "phone" => "79001234567", "bank_code" => "044525225" } })
      assert_equal "amount_below_minimum", service_instance.check_conditions(low_amount, "sbp")[:message]

      invalid_phone = OpenStruct.new(id: "op_3", amount: 1_500,
                                     payout_requisite: { "sbp" => { "phone" => "123", "bank_code" => "044525225" } })
      assert_equal "recipient_phone_invalid_format", service_instance.check_conditions(invalid_phone, "sbp")[:message]

      long_id = OpenStruct.new(id: "x" * 65, amount: 1_500,
                               payout_requisite: { "sbp" => { "phone" => "79001234567", "bank_code" => "044525225" } })
      assert_equal "external_id_too_long", service_instance.check_conditions(long_id, "sbp")[:message]

      card_operation = OpenStruct.new(id: "op_4", amount: 2_000,
                                      payout_requisite: { "card_number" => "4111111111111111" })
      card_payload = service_instance.send(:build_payload, card_operation, "p2p")
      assert_equal "card", card_payload.dig("recipient", "type")
      assert_equal "4111111111111111", card_payload.dig("recipient", "card_number")
      assert service_instance.check_conditions(card_operation, "p2p").key?(:success)

      rate_limit = service_instance.send(:provider_failure, 429, "error" => { "code" => "rate_limit_exceeded" })
      assert_equal :too_many_requests, rate_limit[:failure]
      assert_equal "provider.rate_limit_exceeded", rate_limit[:message]

      callback_result = service_instance.process_callback(
        { "event" => "payout.processing", "payout_id" => "np_2", "status" => "processing" }
      )
      assert callback_result.key?(:success)
      completed_callback = service_instance.process_callback(
        { "event" => "payout.completed", "payout_id" => "np_2", "status" => "completed" }
      )
      assert_equal "np_2", completed_callback[:approved]
      failed_callback = service_instance.process_callback(
        { "event" => "payout.failed", "payout_id" => "np_2", "status" => "failed", "error" => { "code" => "amount_limit_exceeded" } }
      )
      assert_equal "amount_limit_exceeded", failed_callback[:reason]
      conflicting_callback = service_instance.process_callback(
        { "event" => "payout.completed", "payout_id" => "np_2", "status" => "failed" }
      )
      assert_equal "np_2", conflicting_callback[:rejected]

      verification = ProviderGenerator::Verifier.new(
        model, files: files, output: directory, documentation_output: directory
      ).call
      assert verification[:passed], verification[:checks].reject { |check| check[:passed] }.inspect
      assert verification[:checks].any? { |check| check[:name] == "повторяемость" && check[:passed] }

      File.write(File.join(directory, "novapay_service.rb"), service + "\n# изменение после генерации\n")
      changed = ProviderGenerator::Verifier.new(
        model, files: files, output: directory, documentation_output: directory
      ).call
      refute changed[:passed]
      assert changed[:checks].any? { |check| check[:name] == "повторяемость" && !check[:passed] }
      ENV["NOVAPAY_API_KEY"] = previous_api_key
    ensure
      ENV["NOVAPAY_API_KEY"] = previous_api_key if defined?(previous_api_key)
      Object.send(:remove_const, :Provider) if Object.const_defined?(:Provider, false)
      Object.send(:remove_const, :BaseService) if Object.const_defined?(:BaseService, false)
    end
  end
end
