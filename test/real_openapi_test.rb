# frozen_string_literal: true

require "minitest/autorun"
require "tmpdir"
require "digest"
require "json"
require "provider_generator"

class RealOpenapiTest < Minitest::Test
  CORPUS = File.expand_path("fixtures/real_openapi", __dir__)

  def analyze(name)
    source = sources.find { |item| item.fetch("id") == name }
    spec = ProviderGenerator::SpecLoader.load(File.join(CORPUS, source.fetch("file")))
    overrides = ProviderGenerator::OverrideConfig.load(source["overrides"] && File.join(CORPUS, source["overrides"]))
    ProviderGenerator::Analyzer.new(spec, provider: name, overrides: overrides).call
  end

  def sources
    @sources ||= JSON.parse(File.read(File.join(CORPUS, "sources.json"))).fetch("specifications")
  end

  def test_tbank_acquiring_selects_init_and_post_get_state
    model = analyze("tbank")
    assert_equal 37, model.operations.size
    assert_equal "/v2/Init", model.create_operation.path
    assert_equal "/v2/GetState", model.status_operation.path
    assert_equal "post", model.status_operation.method
    assert_equal 1, model.amount_multiplier
    assert model.warnings.any? { |warning| warning.include?("TODO amount_unit") }
    assert_equal "approved", model.statuses["AUTHORIZED"]
    assert model.warnings.any? { |warning| warning.include?("Token/signature") }
  end

  def test_yookassa_prefers_payout_endpoints_but_not_webhook_management
    model = analyze("yookassa")
    assert_equal "/payouts", model.create_operation.path
    assert_equal "/payouts/{payout_id}", model.status_operation.path
    assert_nil model.webhook_operation
    assert_equal "in_progress", model.statuses["pending"]
    assert_equal "rejected", model.statuses["canceled"]
  end

  def test_adyen_checkout_selects_payments_and_reports_missing_status_endpoint
    model = analyze("adyen_checkout")
    assert_equal "/payments", model.create_operation.path
    assert_nil model.status_operation
    assert_equal "approved", model.statuses["Authorised"]
    assert_equal "rejected", model.statuses["Refused"]
  end

  def test_status_extraction_handles_real_provider_dialects
    assert_equal "in_progress", analyze("paypal_orders").statuses["PAYER_ACTION_REQUIRED"]
    assert_equal "in_progress", analyze("stripe").statuses["in_transit"]
    assert_equal "approved", analyze("square").statuses["COMPLETED"]
    assert_equal "in_progress", analyze("ripple").statuses["AWAITING_FUNDING"]
    assert_equal "approved", analyze("fire").statuses["COMPLETE"]
    assert_equal "in_progress", analyze("tbank").statuses["3DS_CHECKING"]
    assert_equal "in_progress", analyze("itpay").statuses["paying"]
  end

  def test_scoring_exposes_why_payout_wins_over_payment
    model = analyze("yookassa")

    assert_equal "/payouts", model.role_scores.dig("create", "selected", "path")
    assert_equal "/payments", model.role_scores.dig("create", "runner_up", "path")
    assert_operator model.role_scores.dig("create", "margin"), :>=, 8
    refute model.warnings.any? { |warning| warning.include?("Неоднозначный выбор операции создания") }
  end

  def test_novapay_is_part_of_real_corpus_with_confirmed_overrides
    model = analyze("novapay")

    assert_equal "/payouts", model.create_operation.path
    assert_equal "/payouts/{payout_id}", model.status_operation.path
    assert_equal "/webhooks/payout", model.webhook_operation.path
    assert_equal 100, model.amount_multiplier
    assert_equal "approved", model.statuses["completed"]
    refute model.warnings.any? { |warning| warning.start_with?("TODO") }
  end

  def test_multiline_operation_descriptions_do_not_break_markdown_tables
    Dir.mktmpdir do |directory|
      ProviderGenerator::Generator.new(analyze("itpay"), output: directory).call
      guide = File.read(File.join(directory, "INTEGRATION.md"))
      row = guide.lines.find { |line| line.include?("Ограничение: повтор доступен только для статусов") }

      refute_nil row
      assert_includes row, "<br><br>Ограничение:"
      assert_match(/\A\| .* \|\n\z/, row)
    end
  end

  def test_every_real_spec_generates_valid_ruby
    sources.each do |source|
      provider = source.fetch("id")
      Dir.mktmpdir do |directory|
        service = ProviderGenerator::Generator.new(analyze(provider), output: directory).call.first
        assert_silent { RubyVM::InstructionSequence.compile_file(service) }
      end
    end
  end

  def test_real_spec_snapshots_match_recorded_digests
    sources.each do |source|
      assert_equal source.fetch("sha256"), Digest::SHA256.file(File.join(CORPUS, source.fetch("file"))).hexdigest
    end
  end


  def test_every_manifest_entry_matches_expected_roles
    sources.each do |source|
      model = analyze(source.fetch("id"))
      expected = source.fetch("expected")
      assert_equal expected.fetch("operations"), model.operations.size, source.fetch("id")
      assert_optional_equal expected["create"], model.create_operation&.path, source.fetch("id")
      assert_optional_equal expected["status"], model.status_operation&.path, source.fetch("id")
      assert_optional_equal expected["webhook"], model.webhook_operation&.path, source.fetch("id")
    end
  end

  def assert_optional_equal(expected, actual, message)
    expected.nil? ? assert_nil(actual, message) : assert_equal(expected, actual, message)
  end
end
