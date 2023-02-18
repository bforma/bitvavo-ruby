RSpec.describe Bitvavo do
  it "has a version number" do
    expect(Bitvavo::VERSION).not_to be nil
  end

  it "can be configured" do
    expect do
      Bitvavo.configure do |config|
        config.base_url = "https://some.base.url"
      end
    end
      .to change { Bitvavo.configuration.base_url }
      .to("https://some.base.url")
  end
end
