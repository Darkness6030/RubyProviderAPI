# frozen_string_literal: true

require_relative "provider_generator/spec_loader"
require_relative "provider_generator/override_config"
require_relative "provider_generator/analyzer"
require_relative "provider_generator/generator"

module ProviderGenerator
  class Error < StandardError; end
end
