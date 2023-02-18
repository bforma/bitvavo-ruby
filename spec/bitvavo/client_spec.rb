RSpec.describe Bitvavo::Client do
  describe "#time" do
    it "returns the server time" do
      stub_request(:get, "https://api.bitvavo.com/v2/time")
        .with(
          headers: {
            "Accept" => "*/*",
            "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
            "User-Agent" => "Faraday v2.7.4"
          }
        )
        .to_return(
          status: 200,
          body: '{"time": 1539180275424}',
          headers: {"Content-Type": "application/json; charset=utf-8"}
        )

      expect(Bitvavo::Client.new.time).to eq(1539180275424)
    end
  end
end
