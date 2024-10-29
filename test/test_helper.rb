require "minitest/autorun"
require "minitest/reporters"
require "webmock/minitest"
require "vcr"
require "water_gauges"

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

VCR.configure do |config|
  config.cassette_library_dir = 'test/fixtures/vcr_cassettes'
  config.hook_into :webmock
  config.ignore_localhost = true
end

WaterGauges.config.user_agent = -> { "WaterGauges Test" }
