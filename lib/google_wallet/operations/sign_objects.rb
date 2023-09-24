# frozen_string_literal: true

require 'jwt'

module GoogleWallet
  module Operations
    class SignObjects
      attr_reader :jwt, :resources, :resource_ids, :objects_type
      DEFAULT_OBJECTS_TYPE = 'genericObjects'

      def initialize(resources: [], resource_ids: [], objects_type: DEFAULT_OBJECTS_TYPE)
        @resources = resources.kind_of?(Array) ? resources : [resources]
        @resource_ids = resource_ids.kind_of?(Array) ? resource_ids : [resource_ids]
        @objects_type = objects_type
        unless resource_ids.empty?
          GoogleWallet.logger.info("You didn't provide objects_type, fallback to use default #{DEFAULT_OBJECTS_TYPE}")
        end
      end

      def call
        payload = {
          iss: GoogleWallet.configuration.json_credentials["client_email"],
          aud: 'google',
          typ: 'savetowallet',
          payload: objects_payload,
          origins: []
        }

        @jwt = JWT.encode(payload, rsa_private_key, 'RS256')

        true
      end

      private

      def objects_payload
        objects.merge(object_ids) { |_key, old_val, new_val| old_val + new_val }
      end

      def objects
        @objects ||= resources.each_with_object({}) do |resource, memo|
          memo[resource.payload_key.to_sym] ||= []
          memo[resource.payload_key.to_sym] << resource.attributes
        end
      end

      def object_ids
        return {} if resource_ids.empty?

        { objects_type.to_sym => resource_ids.map { |resource_id| { id: resource_id } } }
      end

      def rsa_private_key
        @rsa_private_key ||= OpenSSL::PKey::RSA.new(GoogleWallet.configuration.json_credentials["private_key"])
      end
    end
  end
end
