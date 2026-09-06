# frozen_string_literal: true

require "minitest/autorun"
require "provider_generator"
require "tempfile"

class SpecLoaderTest < Minitest::Test
  FIXTURE = File.expand_path("../docs/provider_api.yaml", __dir__)

  def test_loads_and_resolves_local_references
    spec = ProviderGenerator::SpecLoader.load(FIXTURE)
    schema = spec.dig("paths", "/payouts", "post", "requestBody", "content", "application/json", "schema")
    assert_equal "object", schema["type"]
    assert_equal 100_000, schema.dig("properties", "amount", "minimum")
  end

  def test_preserves_recursive_reference_edge
    path = File.expand_path("fixtures/recursive_openapi.yaml", __dir__)
    spec = ProviderGenerator::SpecLoader.load(path)
    schema = spec.dig("paths", "/nodes", "post", "requestBody", "content", "application/json", "schema")

    assert_equal "object", schema["type"]
    assert_equal "#/components/schemas/Node", schema.dig("properties", "child", "$ref")
  end

  def test_analyzes_novapay_contract
    overrides = ProviderGenerator::OverrideConfig.load(File.expand_path("../docs/novapay_overrides.yaml", __dir__))
    model = ProviderGenerator::Analyzer.new(ProviderGenerator::SpecLoader.load(FIXTURE), provider: "novapay", overrides: overrides).call
    assert_equal 5, model.operations.length
    assert_equal "createPayout", model.create_operation.id
    assert_equal "getPayoutStatus", model.status_operation.id
    assert_equal "approved", model.statuses["completed"]
    assert_equal 100, model.amount_multiplier
    assert_match(/X-NovaPay-Signature/, model.webhook_signature)
    refute model.warnings.any? { |warning| warning.start_with?("TODO") }
  end

  def test_reports_text_only_semantics_without_overrides
    model = ProviderGenerator::Analyzer.new(ProviderGenerator::SpecLoader.load(FIXTURE), provider: "novapay").call

    assert_equal 1, model.amount_multiplier
    assert model.warnings.any? { |warning| warning.include?("TODO amount_unit") }
    assert model.warnings.any? { |warning| warning.include?("TODO required_if recipient.bank_code") }
    assert model.warnings.any? { |warning| warning.include?("TODO webhook_signature") }
  end

  def test_rejects_invalid_override_values
    file = Tempfile.new(["invalid-overrides", ".yaml"])
    file.write("version: 1\namount:\n  multiplier: 0\n")
    file.close

    error = assert_raises(ProviderGenerator::Error) { ProviderGenerator::OverrideConfig.load(file.path) }
    assert_includes error.message, "положительным"
  ensure
    file&.close!
  end
end
