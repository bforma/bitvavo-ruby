RSpec.describe Bitvavo::Client do
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

  describe "#markets" do
    it "returns information on the markets" do
      stub_request(:get, "https://api.bitvavo.com/v2/markets")
        .to_return(
          status: 200,
          body: <<~JSON,
            [
              {
                "market": "BTC-EUR",
                "status": "trading",
                "base": "BTC",
                "quote": "EUR",
                "pricePrecision": "5",
                "minOrderInQuoteAsset": "10",
                "minOrderInBaseAsset": "0.001",
                "orderTypes": [
                  "market",
                  "limit",
                  "stopLoss",
                  "stopLossLimit",
                  "takeProfit",
                  "takeProfitLimit"
                ]
              }
            ]
          JSON
          headers: {"Content-Type": "application/json; charset=utf-8"}
        )

      expect(Bitvavo::Client.new.markets).to eq(
        [
          {
            "market" => "BTC-EUR",
            "status" => "trading",
            "base" => "BTC",
            "quote" => "EUR",
            "pricePrecision" => "5",
            "minOrderInQuoteAsset" => "10",
            "minOrderInBaseAsset" => "0.001",
            "orderTypes" => %w[market limit stopLoss stopLossLimit takeProfit takeProfitLimit]
          }
        ]
      )
    end

    it "returns information on a specific market" do
      stub_request(:get, "https://api.bitvavo.com/v2/markets?market=ETH-EUR")
        .to_return(
          status: 200,
          body: <<~JSON,
            [
              {
                "market": "ETH-EUR",
                "status": "trading",
                "base": "ETH",
                "quote": "EUR",
                "pricePrecision": "5",
                "minOrderInQuoteAsset": "10",
                "minOrderInBaseAsset": "0.001",
                "orderTypes": [
                  "market",
                  "limit",
                  "stopLoss",
                  "stopLossLimit",
                  "takeProfit",
                  "takeProfitLimit"
                ]
              }
            ]
          JSON
          headers: {"Content-Type": "application/json; charset=utf-8"}
        )

      expect(Bitvavo::Client.new.markets("ETH-EUR")).to eq(
        [
          {
            "market" => "ETH-EUR",
            "status" => "trading",
            "base" => "ETH",
            "quote" => "EUR",
            "pricePrecision" => "5",
            "minOrderInQuoteAsset" => "10",
            "minOrderInBaseAsset" => "0.001",
            "orderTypes" => %w[market limit stopLoss stopLossLimit takeProfit takeProfitLimit]
          }
        ]
      )
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

  describe "authentication" do
    it "adds the API key and signature to the request" do
      Timecop.freeze(Time.at(1676790988.943))

      stub_request(:get, "https://api.bitvavo.com/v2/account")
        .with(
          headers: {
            "Accept" => "*/*",
            "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
            "Bitvavo-Access-Key" => "key",
            "Bitvavo-Access-Signature" => "124299941c9ed3029d1f4b72f7f445d47fbd9ba568bf68ed55e0ed338e668c79",
            "Bitvavo-Access-Timestamp" => "1676790988943",
            "User-Agent" => "Faraday v2.7.4"
          }
        )
        .to_return(
          status: 200
        )

      Bitvavo::Client.new.account
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
