# google_wallet/configuration.rb

require 'json'

module GoogleWallet
  class Configuration
    attr_accessor :json_credentials, :issuer_id, :api_endpoint, :debug_mode

    def initialize
      @json_credentials = nil
      @issuer_id = nil
      @api_endpoint = 'https://api.example.com'
      @debug_mode = false
    end

    def load_credentials_from_file(file_path)
      begin
        json_data = JSON.parse(File.read(file_path))
        @json_credentials = json_data
      rescue JSON::ParserError, Errno::ENOENT => e
        raise "Error loading JSON credentials from file: #{e.message}"
      end
    end
  end
end
