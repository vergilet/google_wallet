# frozen_string_literal: true

module GoogleWallet
  module Resources
    class Base
      attr_reader :options

      def initialize(attributes: {}, options: {})
        @options = options

        attributes.each do |key, value|
          instance_variable_set("@#{key}", value)
        end
      end

      def attributes
        hash = deep_merge(template, options)
        remove_empty_values(hash)
      end

      def payload_key
        raise 'Define in resource'
      end

      private

      def payload_key_logic
        self.class.name.split("::")[-2].tap { |obj| obj[0] = obj[0].downcase }
      end

      def validate_fields(fields = [])
        fields.each do |field|
          raise "#{self.class.name} - #{field} is required" if blank?(instance_variable_get("@#{field}"))
        end
      end

      def deep_merge(hash1, hash2)
        hash1.merge(hash2) do |_key, old_val, new_val|
          old_val.is_a?(Hash) && new_val.is_a?(Hash) ? deep_merge(old_val, new_val) : new_val
        end
      end

      def remove_empty_values(hash)
        hash.reject { |_key, value| value.nil? || value == '' || value == {} }
      end

      def blank?(value)
        value.nil? || value.to_s.strip.empty?
      end

      def present?(value)
        !blank?(value)
      end
    end
  end
end
