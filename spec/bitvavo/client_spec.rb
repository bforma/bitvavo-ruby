RSpec.describe Bitvavo::Client do
  before do
    Bitvavo.configure do |config|
      config.api_key = "key"
      config.api_secret = "secret"
    end
  end

  describe "#time" do
    it "returns the current timestamp in milliseconds since 1 Jan 1970" do
      stub_request(:get, "https://api.bitvavo.com/v2/time")
        .to_return(
          status: 200,
          body: <<~JSON,
            {
              "time": 1539180275424
            }
          JSON
          headers: {"Content-Type": "application/json; charset=utf-8"}
        )

      expect(Bitvavo::Client.new.time).to eq(1539180275424)
    end
  end

  describe "#account" do
    it "returns the current fees for this account" do
      Bitvavo.configure do |config|
        config.api_key = "key"
        config.api_secret = "secret"
      end

      stub_request(:get, "https://api.bitvavo.com/v2/account")
        .to_return(
          status: 200,
          body: <<~JSON,
            {
              "fees": {
                "taker": "0.0025",
                "maker": "0.0015",
                "volume": "10000.00"
              }
            }
          JSON
          headers: {"Content-Type": "application/json; charset=utf-8"}
        )

      expect(Bitvavo::Client.new.account).to eq(
        {
          "fees" => {
            "taker" => "0.0025",
            "maker" => "0.0015",
            "volume" => "10000.00"
          }
        }
      )
    end
  end

  describe "error handling" do
    it "raises an error when the API key is invalid" do
      stub_request(:get, "https://api.bitvavo.com/v2/time")
        .to_return(
          status: 403,
          body: <<~JSON,
            {
               "errorCode": 305,
               "error": "No active API key found."
            }
          JSON
          headers: {"Content-Type": "application/json; charset=utf-8"}
        )

      expect { Bitvavo::Client.new.time }.to raise_error(Faraday::ForbiddenError)
    end
  end
end
