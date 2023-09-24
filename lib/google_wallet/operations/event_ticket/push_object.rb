# frozen_string_literal: true

require 'httparty'

module GoogleWallet
  module Operations
    module EventTicket
      class PushObject
        ENDPOINT = 'eventTicketObject'

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

          if GoogleWallet.debug_mode?
            GoogleWallet.logger.debug(self.class.name)
            GoogleWallet.logger.debug(__method__)
            GoogleWallet.logger.debug(response.inspect)
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

          if GoogleWallet.debug_mode?
            GoogleWallet.logger.debug(self.class.name)
            GoogleWallet.logger.debug(__method__)
            GoogleWallet.logger.debug(response.inspect)
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

          if GoogleWallet.debug_mode?
            GoogleWallet.logger.debug(self.class.name)
            GoogleWallet.logger.debug(__method__)
            GoogleWallet.logger.debug(response.inspect)
          end

          response.success?
        end
      end
    end
  end
end
