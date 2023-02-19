RSpec.describe Bitvavo::Authentication do
  it "sets authentication headers" do
    Timecop.freeze(Time.at(1676790988.943))

    env = Faraday::Env.new(
      method: :get,
      url: URI("https://api.bitvavo.com/v2/time"),
      request_body: nil,
      request_headers: {}
    )

    expect do
      Bitvavo::Authentication.new(nil).on_request(env)
    end
      .to change { env.request_headers }
      .to(
        "Bitvavo-Access-Key" => "key",
        "Bitvavo-Access-Signature" => "f4695a60a4fc2a8fed6294b4140e498264a052e70ccd7b0d45217af2378cb106",
        "Bitvavo-Access-Timestamp" => "1676790988943"
      )
  end
end
