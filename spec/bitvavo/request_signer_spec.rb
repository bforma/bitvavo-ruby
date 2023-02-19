RSpec.describe Bitvavo::RequestSigner do
  it "creates a signature" do
    expect(
      Bitvavo::RequestSigner
        .sign_request(
          secret: "bitvavo",
          timestamp: 1548172481125,
          method: "POST",
          path: "/v2/order",
          body: '{"market":"BTC-EUR","side":"buy","price":"5000","amount":"1.23","orderType":"limit"}'
        )
    ).to eq("44d022723a20973a18f7ee97398b9fdd405d2d019c8d39e24b8cc0dcb39ca016")
  end

  it "creates a signature when request method is a lower case symbol" do
    expect(
      Bitvavo::RequestSigner
        .sign_request(
          secret: "bitvavo",
          timestamp: 1548172481125,
          method: :post,
          path: "/v2/order",
          body: '{"market":"BTC-EUR","side":"buy","price":"5000","amount":"1.23","orderType":"limit"}'
        )
    ).to eq("44d022723a20973a18f7ee97398b9fdd405d2d019c8d39e24b8cc0dcb39ca016")
  end

  it "fails when no API secret is configured" do
    expect do
      Bitvavo::RequestSigner.sign_request(
        secret: nil,
        timestamp: 123,
        method: "GET",
        path: "/time",
        body: ""
      )
    end
      .to raise_error("No API secret configured")
  end
end
