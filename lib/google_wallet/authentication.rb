# lib/google_wallet/authentication.rb

require 'googleauth'

module GoogleWallet
  class Authentication
    SCOPE = 'https://www.googleapis.com/auth/wallet_object.issuer'

    def initialize
      @credentials = GoogleWallet.configuration.json_credentials
    end

    def access_token
      if @credentials
        begin
          credentials = Google::Auth::ServiceAccountCredentials.make_creds(
            json_key_io: StringIO.new(@credentials.to_json),
            scope: SCOPE
          )

          credentials.fetch_access_token!
          credentials.access_token
        rescue StandardError => e
          puts "Error while fetching access token: #{e.message}"
          nil
        end
      else
        puts "No credentials provided."
        nil
      end
    end
  end
end
