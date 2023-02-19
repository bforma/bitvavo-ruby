require "faraday"

require_relative "authentication"

module Bitvavo
  class Client
    def initialize(base_url: Bitvavo.configuration.base_url)
      @base_url = base_url
    end

    def time
      public_connection
        .get("time")
        .body["time"]
    end

    def markets(market = nil)
      public_connection
        .get("markets") do |req|
          req.params["market"] = market if market
        end
        .body
    end

    def assets(symbol = nil)
      public_connection
        .get("assets") do |req|
          req.params["symbol"] = symbol if symbol
        end
        .body
    end

    def account
      private_connection
        .get("account")
        .body
    end

    def balance(symbol = nil)
      private_connection
        .get("balance") do |req|
          req.params["symbol"] = symbol if symbol
        end
        .body
    end

    def trades(market)
      private_connection
        .get("trades") do |req|
          req.params["market"] = market
        end
        .body
    end

    private

    def public_connection
      connection(private: false)
    end

    def private_connection
      connection(private: true)
    end

    def connection(private:)
      Faraday.new(@base_url) do |f|
        f.use Bitvavo::Authentication if private

        f.response :raise_error
        f.response :json
      end
    end
  end
end
