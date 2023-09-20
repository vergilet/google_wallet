# frozen_string_literal: true

require 'httparty'

module GoogleWallet
  module Operations
    class RegisterEventTicketClass
      ENDPOINT = 'eventTicketClass'

      def initialize(resource:, access_token:)
        @resource = resource
        @access_token = access_token
      end

      def call
        return update_class if exists?
        create_class
      end

      private

      attr_reader :resource, :access_token

      def exists?
        response = HTTParty.get(
          "#{GoogleWallet.configuration.api_endpoint}/#{ENDPOINT}/#{resource.id}",
          query: { access_token: access_token }
        )

        if GoogleWallet.configuration.debug_mode
          pp self.class.name
          pp __method__
          pp response.inspect
        end

        response.success?
      end

      def create_class
        response = HTTParty.post(
          "#{GoogleWallet.configuration.api_endpoint}/#{ENDPOINT}",
          query: { access_token: access_token },
          body: resource.attributes.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )
        if GoogleWallet.configuration.debug_mode
          pp self.class.name
          pp __method__
          pp response.inspect
        end

        response.success?
      end

      def update_class
        response = HTTParty.put(
          "#{GoogleWallet.configuration.api_endpoint}/#{ENDPOINT}/#{resource.id}",
          query: {access_token: access_token},
          body: resource.attributes.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

        if GoogleWallet.configuration.debug_mode
          pp self.class.name
          pp __method__
          pp response.inspect
        end

        response.success?
      end
    end
  end
end
