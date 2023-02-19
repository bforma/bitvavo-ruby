require "faraday"

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

    private

    def public_connection
      Faraday.new(@base_url) do |f|
        f.response :json
      end
    end
  end
end
