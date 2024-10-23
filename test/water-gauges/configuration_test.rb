require "test_helper"

class WaterGauges::ConfigurationTest < Minitest::Test
  def test_default_configuration
    assert_equal "WaterGauges Test", WaterGauges.config.user_agent
    assert_equal 30, WaterGauges.config.timeout
  end

  def test_configuration_update
    original_timeout = WaterGauges.config.timeout

    WaterGauges.config.timeout = 60
    assert_equal 60, WaterGauges.config.timeout

    # Reset for other tests
    WaterGauges.config.timeout = original_timeout
  end
end
