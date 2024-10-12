# frozen_string_literal: true

module GoogleWallet
  module Resources
    module EventTicket
      class Object < Base

        attr_reader :object_identifier, :class_identifier, :seat, :row, :section, :gate,
                    :ticket_type, :grouping_id, :qr_code_value, :qr_alternate_text, :ticket_holder_name,
                    :valid_time_start, :valid_time_end, :micros, :currency_code,
                    :hex_background_color, :ticket_number, :id, :class_id, :options


        # attributes = {
        #   object_identifier: 'fd9b637f-0381-42ad-9161-b4d887d79d9f',
        #   class_identifier: 'Event-1234',
        #   grouping_id: 'order-12345',
        #   ticket_type: 'Vip Pass + Priority24',
        #   section: 'The Sponsor Felt-F Overpower',
        #   seat: '65',
        #   row: '17',
        #   gate: 'G3, G4',
        #   ticket_holder_name: 'Yaro Developer',
        #   qr_code_value: '12345678',
        #   qr_alternate_text: 'visible qr value'
        #   ticket_number: 'cdeqw',
        #   valid_time_start: '2023-09-27T22:30',
        #   valid_time_end: '2023-09-28T02:00',
        #   micros: 82_000_000,
        #   currency_code: 'NOK',
        #   hex_background_color: '#45ffaa'
        # }

        def initialize(attributes: {}, options: {})
          super

          validate_fields( %w[object_identifier class_identifier])
          @id = "#{GoogleWallet.configuration.issuer_id}.#{@object_identifier}"
          @class_id = "#{GoogleWallet.configuration.issuer_id}.#{@class_identifier}"
        end

        def push
          access_token = GoogleWallet::Authentication.new.access_token
          GoogleWallet::Operations::EventTicket::PushObject.new(resource: self, access_token: access_token).call
        end

        def sign(push_resource: true)
          sign_operation =
            if push_resource
              push
              GoogleWallet::Operations::SignObjects.new(resource_ids: [id], objects_type: self.payload_key)
            else
              GoogleWallet::Operations::SignObjects.new(resources: [itself])
            end

          sign_operation.call
          sign_operation.jwt
        end

        def payload_key
          "#{payload_key_logic}Objects"
        end

        private

        def template
          template = {}

          template[:id] = id
          template[:classId] = class_id
          template[:state] = "ACTIVE"

          template[:ticketType] = { defaultValue: { language: "en-us", value: ticket_type } } if present?(ticket_type)
          template[:groupingInfo] = { groupingId: grouping_id } if present?(grouping_id)
          if present?(qr_code_value)
            alternate_text = qr_alternate_text || qr_code_value
            template[:barcode] = { type: "QR_CODE", value: qr_code_value, alternateText: alternate_text }
          end
          template[:faceValue] = { micros: micros, currencyCode: currency_code } if present?(micros) && present?(currency_code)

          template[:seatInfo] = {}
          template[:seatInfo][:seat] = { defaultValue: { language: "en-us", value: seat } } if present?(seat)
          template[:seatInfo][:row] = { defaultValue: { language: "en-us", value: row } } if present?(row)
          template[:seatInfo][:section] = { defaultValue: { language: "en-us", value: section } } if present?(section)
          template[:seatInfo][:gate] = { defaultValue: { language: "en-us", value: gate } } if present?(gate)

          template[:validTimeInterval] = {}
          template[:validTimeInterval][:start] = { date: valid_time_start } if present?(valid_time_start)
          template[:validTimeInterval][:end] = { date: valid_time_end } if present?(valid_time_end)

          template[:hexBackgroundColor] = hex_background_color if present?(hex_background_color)
          template[:ticketHolderName] = ticket_holder_name if present?(ticket_holder_name)
          template[:ticketNumber] = ticket_number if present?(ticket_number)

          template
        end
      end
    end
  end
end
