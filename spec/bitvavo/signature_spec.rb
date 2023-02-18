RSpec.describe "Bitvavo::Signature" do
  it "creates a signature" do
    expect(
      Bitvavo::Signature
        .create(
          "bitvavo",
          1548172481125,
          "POST",
          "/v2/order",
          '{"market":"BTC-EUR","side":"buy","price":"5000","amount":"1.23","orderType":"limit"}'
        )
    ).to eq("44d022723a20973a18f7ee97398b9fdd405d2d019c8d39e24b8cc0dcb39ca016")
  end

  it "fails when no API secret is configured" do
    expect { Bitvavo::Signature.create(nil, 123, "GET", "/time", "") }
      .to raise_error("No API secret configured")
  end
end
