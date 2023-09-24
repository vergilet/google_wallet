# google_wallet/configuration.rb

require 'json'

module GoogleWallet
  class Configuration
    attr_accessor :json_credentials, :issuer_id, :api_endpoint, :debug_mode, :logger

    def initialize
      @api_endpoint = 'https://walletobjects.googleapis.com/walletobjects/v1'
      @json_credentials = nil
      @issuer_id = nil
      @debug_mode = false
      @logger = Logger.new(STDOUT)
    end

    def self.logger
      @logger
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
