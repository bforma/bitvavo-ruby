require "active_support/configurable"

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
  end
end