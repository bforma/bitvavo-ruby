require "faraday"

require_relative "authentication"

module Bitvavo
  class Client
    def initialize(base_url: Bitvavo.configuration.base_url)
      @base_url = base_url
    end

    def time
      connection
        .get("time")
        .body["time"]
    end

    def markets(market = nil)
      connection
        .get("markets") do |req|
          req.params["market"] = market if market
        end
        .body
    end

    def account
      connection
        .get("account")
        .body
    end

    private

    def connection
      Faraday.new(@base_url) do |f|
        f.use Bitvavo::Authentication

        f.response :raise_error
        f.response :json
      end
    end
  end
end
