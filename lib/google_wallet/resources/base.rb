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
        deep_merge(template, options)
      end

      private

      def deep_merge(hash1, hash2)
        hash1.merge(hash2) do |_key, old_val, new_val|
          old_val.is_a?(Hash) && new_val.is_a?(Hash) ? deep_merge(old_val, new_val) : new_val
        end
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
