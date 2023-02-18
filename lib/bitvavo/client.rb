require "faraday"

module Bitvavo
  class Client
    def time
      conn = Faraday.new("https://api.bitvavo.com/v2") do |f|
        f.response :json
      end

      response = conn.get("time")
      response.body["time"]
    end
  end
end
