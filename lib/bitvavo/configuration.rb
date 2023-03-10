require "active_support/configurable"

require_relative "credentials"

module Bitvavo
  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield configuration
    end
  end

  class Configuration
    include ActiveSupport::Configurable

    config_accessor(:base_url) { "https://api.bitvavo.com/v2" }
    config_accessor(:api_key) { Credentials["api_key"] }
    config_accessor(:api_secret) { Credentials["api_secret"] }
  end
end
