# frozen_string_literal: true

require "minitest/autorun"
require "open3"
require "rbconfig"
require "tmpdir"

class CliTest < Minitest::Test
  ROOT = File.expand_path("..", __dir__)

  def test_verify_checks_generated_package
    Dir.mktmpdir do |directory|
      output, error, status = Open3.capture3(
        RbConfig.ruby,
        File.join(ROOT, "bin/integrate"),
        "--spec", File.join(ROOT, "examples/novapay/openapi.yaml"),
        "--provider", "novapay",
        "--overrides", File.join(ROOT, "examples/novapay/overrides.yaml"),
        "--output", directory,
        "--verify"
      )

      assert status.success?, "#{output}\n#{error}"
      assert_includes output, "Проверка сгенерированного пакета"
      assert_includes output, "✓ повторяемость"
      assert_includes output, "✓ сценарий без сети"
    end
  end
end
