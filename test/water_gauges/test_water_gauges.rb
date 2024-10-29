require 'test_helper'

class TestWaterGauges < Minitest::Test
  def test_user_agent_default
    user_agent_proc = WaterGauges.config.user_agent
    assert_kind_of Proc, user_agent_proc
    assert_match(/WaterGauges Test/, user_agent_proc.call)
  end

  def test_timeout_default
    assert_equal 30, WaterGauges.config.timeout
  end

  def test_base_urls
    assert_equal "https://dwr.state.co.us/Rest/GET/api/v2", WaterGauges.config.base_urls.dwr
    assert_equal "https://waterservices.usgs.gov/nwis", WaterGauges.config.base_urls.usgs
  end

  def test_default_parameters
    assert_equal "DISCHRG", WaterGauges.config.default_parameters.dwr
    assert_equal "00060", WaterGauges.config.default_parameters.usgs
  end

  def test_client_dwr
    client = WaterGauges.client(:dwr)
    assert_instance_of WaterGauges::Agencies::Dwr::Client, client
  end

  # def test_client_usgs
  #   client = WaterGauges.client(:usgs)
  #   assert_instance_of WaterGauges::Agencies::Usgs::Client, client
  # end

  # def test_client_invalid_agency
  #   error = assert_raises(WaterGauges::Errors::UnsupportedAgencyError) do
  #     WaterGauges.client(:invalid_agency)
  #   end
  #   assert_equal "Unsupported agency: invalid_agency", error.message
  # end

  def test_autoloader_setup
    assert WaterGauges.const_defined?(:Agencies), "Agencies module should be autoloaded"
    assert WaterGauges::Agencies.const_defined?(:Dwr), "Dwr module should be autoloaded"
    assert WaterGauges::Agencies::Dwr.const_defined?(:Client), "Dwr::Client should be autoloaded"
  end
end
