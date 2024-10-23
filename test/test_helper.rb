require "minitest/autorun"
require "minitest/reporters"
require "webmock/minitest"
require "vcr"
require "water-gauges"

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

# Configure VCR
VCR.configure do |config|
  config.cassette_library_dir = "test/fixtures/vcr_cassettes"
  config.hook_into :webmock
end

# Configure WaterGauges for testing
WaterGauges.config.user_agent = "WaterGauges Test"
