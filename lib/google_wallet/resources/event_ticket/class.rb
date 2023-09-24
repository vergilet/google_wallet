# frozen_string_literal: true

module GoogleWallet
  module Resources
    module EventTicket
      class Class < Base
        attr_reader :class_identifier, :issuer_name, :logo_url, :event_id, :event_name,
                    :venue_name, :venue_address, :start_date_time, :end_date_time, :country_code,
                    :hex_background_color, :hero_image_url, :homepage_url, :callback_url, :id


        # attributes = {
        #   class_identifier: 'Event-1234',
        #   issuer_name: 'iChar System',
        #   event_name: 'Solo Singing Contest #1 Yay!',
        #   event_id: '123456',
        #   logo_url: 'https://images.unsplash.com/photo-1475721027785-f74eccf877e2?auto=format&fit=crop&w=360&h=360',
        #   hero_image_url: 'https://images.unsplash.com/photo-1501281668745-f7f57925c3b4?auto=format&fit=crop&w=1032&h=336'
        #   homepage_url: 'https://arrangement.ticketco.events',
        #   country_code: 'no',
        #   venue_name: 'Opera Theater',
        #   venue_address: "Shevchenka street 41/5, Ukraine, Lviv",
        #   start_date_time: '2023-08-27T22:30',
        #   end_date_time: '2023-08-28T01:30',
        #   hex_background_color: '#ff0077',
        #   callback_url: 'https://example.com/gpass_callback'
        # }


        def initialize(attributes: {}, options: {})
          super
          validate_fields( %w[class_identifier event_name issuer_name])
          @id = "#{GoogleWallet.configuration.issuer_id}.#{@class_identifier}"
        end

        def push
          access_token = GoogleWallet::Authentication.new.access_token
          GoogleWallet::Operations::EventTicket::PushClass.new(resource: self, access_token: access_token).call
        end

        def sign(push_resource: true)
          raise "Class cannot be signed without Object,
                use GoogleWallet::Operations::SignObjects.new(...)
                to create/modify simultaneously classes and objects by following jwt link"
        end

        def payload_key
          "#{payload_key_logic}Classes"
        end

        private

        def template
          template = {}

          template[:id] = id
          template[:issuerName] = issuer_name
          template[:eventName] =  { defaultValue: { language: "en-US", value: event_name } }
          template[:reviewStatus] =  "UNDER_REVIEW"

          template[:eventId] = event_id if present?(event_id)
          template[:logo] = { sourceUri: { uri: logo_url } } if present?(logo_url)
          template[:heroImage] = { sourceUri: { uri: hero_image_url } } if present?(hero_image_url)

          template[:homepageUri] = { uri: homepage_url, description: 'Homepage' } if present?(homepage_url)
          template[:countryCode] = country_code if present?(country_code)
          template[:hexBackgroundColor] = hex_background_color if present?(hex_background_color)
          template[:callbackOptions] = { url: callback_url } if present?(callback_url)

          template[:securityAnimation] = { animationType: "FOIL_SHIMMER" }

          template[:venue] = {}
          template[:venue][:name] = { defaultValue: { language: "en-US", value: venue_name } } if present?(venue_name)
          template[:venue][:address] = { defaultValue: { language: "en-US", value: venue_address } } if present?(venue_address)

          template[:dateTime] = {}
          template[:dateTime][:start] = start_date_time if present?(start_date_time)
          template[:dateTime][:end] = end_date_time if present?(end_date_time)

          template
        end
      end
    end
  end
end
