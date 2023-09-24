# frozen_string_literal: true

require_relative "google_wallet/version"
require_relative "google_wallet/configuration"
require_relative "google_wallet/authentication"

require_relative "google_wallet/resources/base"
require_relative "google_wallet/resources/event_ticket/class"
require_relative "google_wallet/resources/event_ticket/object"

require_relative "google_wallet/operations/sign_objects"
require_relative "google_wallet/operations/event_ticket/push_class"
require_relative "google_wallet/operations/event_ticket/push_object"

module GoogleWallet
  class Error < StandardError; end

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  def self.logger
    configuration.logger
  end

  def self.debug_mode?
    configuration.debug_mode
  end
end
