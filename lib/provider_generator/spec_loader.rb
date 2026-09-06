# frozen_string_literal: true

require "json"
require "yaml"
require "date"

module ProviderGenerator
  class SpecLoader
    class << self
      def load(path)
        raise Error, "Файл спецификации не найден: #{path}" unless File.file?(path)

        data = parse(File.read(path, encoding: "UTF-8"), File.extname(path))
        data = Swagger2Adapter.new(data).call if data["swagger"].to_s == "2.0"
        version = data["openapi"].to_s
        raise Error, "Ожидалась OpenAPI 3.x, получено: #{version.empty? ? 'версия не указана' : version}" unless version.start_with?("3.")
        raise Error, "В спецификации отсутствует объект paths." unless data["paths"].is_a?(Hash)

        Resolver.new(data).resolve(data)
      rescue Psych::Exception, JSON::ParserError => e
        raise Error, "Некорректная спецификация: #{e.message}"
      end

      private

      def parse(source, extension)
        return JSON.parse(source) if extension.downcase == ".json"

        value = YAML.safe_load(source, permitted_classes: [Date, Time], permitted_symbols: [], aliases: false) || {}
        normalize_yaml_scalars(value)
      end

      def normalize_yaml_scalars(value)
        case value
        when Array then value.map { |item| normalize_yaml_scalars(item) }
        when Hash then value.to_h { |key, child| [key.to_s, normalize_yaml_scalars(child)] }
        when Date, Time then value.iso8601
        else value
        end
      end
    end

    class Swagger2Adapter
      HTTP_METHODS = %w[get post put patch delete options head].freeze
      def initialize(spec)
        @spec = rewrite_refs(spec)
      end

      def call
        {
          "openapi" => "3.0.0",
          "info" => @spec["info"],
          "servers" => servers,
          "security" => @spec["security"],
          "paths" => @spec.fetch("paths", {}).to_h { |path, item| [path, convert_path(item)] },
          "components" => {
            "schemas" => @spec.fetch("definitions", {}),
            "securitySchemes" => @spec.fetch("securityDefinitions", {}),
            "responses" => @spec.fetch("responses", {})
          }
        }.compact
      end

      private

      def servers
        Array(@spec["schemes"] || "https").map do |scheme|
          { "url" => "#{scheme}://#{@spec['host']}#{@spec['basePath']}".sub(%r{/$}, "") }
        end
      end

      def convert_path(item)
        item.to_h do |key, value|
          next [key, value] unless HTTP_METHODS.include?(key)
          [key, convert_operation(value, item)]
        end
      end

      def convert_operation(operation, path_item)
        parameters = Array(path_item["parameters"]) + Array(operation["parameters"])
        body = parameters.find { |parameter| parameter["in"] == "body" }
        result = operation.merge(
          "summary" => operation["summary"] || operation["description"],
          "parameters" => parameters.reject { |parameter| parameter["in"] == "body" },
          "responses" => convert_responses(operation.fetch("responses", {}))
        )
        if body
          media = Array(operation["consumes"] || @spec["consumes"] || "application/json").first
          result["requestBody"] = { "required" => body["required"], "content" => { media => { "schema" => body["schema"] || {} } } }
        end
        result
      end

      def convert_responses(responses)
        media = Array(@spec["produces"] || "application/json").first
        responses.to_h do |code, response|
          converted = response.dup
          converted["content"] = { media => { "schema" => response["schema"] } } if response["schema"]
          [code.to_s, converted]
        end
      end

      def rewrite_refs(value)
        case value
        when Array then value.map { |item| rewrite_refs(item) }
        when Hash
          value.to_h do |key, child|
            child = child.sub("#/definitions/", "#/components/schemas/") if key == "$ref" && child.is_a?(String)
            [key, rewrite_refs(child)]
          end
        else value
        end
      end
    end

    class Resolver
      def initialize(root)
        @root = root
        @cache = {}
      end

      def resolve(value, stack = [])
        case value
        when Array then value.map { |item| resolve(item, stack) }
        when Hash
          return resolve_reference(value, stack) if value.key?("$ref")

          value.to_h { |key, child| [key, resolve(child, stack)] }
        else value
        end
      end

      private

      def resolve_reference(value, stack)
        reference = value.fetch("$ref")
        # Do not fetch remote schemas implicitly: that would make generation
        # non-reproducible and could cross a trust boundary. Preserve the edge;
        # fields available in the main document remain analyzable.
        return value unless reference.start_with?("#/")
        # Recursive schemas are valid OpenAPI (linked lists, trees, nested files).
        # Keep the recursion edge as a reference: consumers still get the resolved
        # outer shape without infinitely expanding the document.
        return value if stack.include?(reference)

        target = reference.delete_prefix("#/").split("/").reduce(@root) do |node, token|
          key = token.gsub("~1", "/").gsub("~0", "~")
          return nil unless node.is_a?(Hash) && node.key?(key)
          node[key]
        end
        return value if target.nil?
        siblings = value.reject { |key, _| key == "$ref" }
        return resolve(target.merge(siblings), stack + [reference]) unless siblings.empty?

        # Large payment specifications reuse the same models hundreds of times.
        # Resolve each plain reference once and share the immutable-by-convention
        # result instead of expanding the entire schema graph at every use site.
        @cache[reference] ||= resolve(target, stack + [reference])
      end
    end
  end
end
