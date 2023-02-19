RSpec.describe Bitvavo::Credentials do
  it "returns credentials from a file when present" do
    Bitvavo::Credentials.reset!

    allow(Bitvavo::Credentials).to receive(:path).and_return("spec/fixtures/credentials")

    expect(Bitvavo::Credentials["api_key"]).to eq("some-key")
    expect(Bitvavo::Credentials["api_secret"]).to eq("some-secret")
  end

  it "returns nil values when credentials file is not present" do
    Bitvavo::Credentials.reset!

    allow(Bitvavo::Credentials).to receive(:path).and_return("spec/fixtures/not_found")

    expect(Bitvavo::Credentials["api_key"]).to be_nil
    expect(Bitvavo::Credentials["api_secret"]).to be_nil
  end
end
