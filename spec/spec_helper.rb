require "bitvavo"
require "webmock/rspec"
require "timecop"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before do
    Bitvavo.configure do |config|
      config.api_key = "key"
      config.api_secret = "secret"
    end
  end

  config.after do
    Timecop.return
  end
end
