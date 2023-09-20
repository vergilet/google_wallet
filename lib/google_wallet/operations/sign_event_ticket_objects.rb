# frozen_string_literal: true

require 'jwt'

module GoogleWallet
  module Operations
    class SignEventTicketObjects
      attr_reader :jwt, :resources

      def initialize(resources:)
        @resources = resources.kind_of?(Array) ? resources : [resources]
      end

      def call
        event_ticket_objects = resources.map do |resource|
          if GoogleWallet.configuration.debug_mode
            register_operation = GoogleWallet::Operations::RegisterEventTicketObject.new(resource: resource, access_token: GoogleWallet::Authentication.new.access_token)
            register_operation.call
          end

          resource.attributes
        end


        rsa_private = OpenSSL::PKey::RSA.new(GoogleWallet.configuration.json_credentials["private_key"])
        payload = {
          "iss": GoogleWallet.configuration.json_credentials["client_email"],
          "aud": 'google',
          "typ": 'savetowallet',
          "payload": { eventTicketObjects: event_ticket_objects },
          "origins": []
        }

        @jwt = JWT.encode(payload, rsa_private, 'RS256')

        true
      end
    end
  end
end
