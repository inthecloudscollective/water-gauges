require 'test_helper'

class WaterGauges::Agencies::Dwr::TestTelemetry < Minitest::Test
  def setup
    @client = WaterGauges.client(:dwr)
  end

  def test_get_telemetry_stations
    VCR.use_cassette('dwr_get_telemetry_stations') do
      stations = @client.get_telemetry_stations(county: 'Denver')
      assert_kind_of Array, stations
      refute_empty stations
      station = stations.first
      assert_kind_of WaterGauges::Agencies::Models::Dwr::Station, station
    end
  end

  def test_get_telemetry_ts
    VCR.use_cassette('dwr_get_telemetry_ts') do
      readings = @client.get_telemetry_ts(
        abbrev: 'PLACHECO',
        parameter: 'DISCHRG',
        start_date: Date.parse('2021-01-01'),
        end_date: Date.parse('2021-12-31'),
        timescale: 'day'
      )
      assert_kind_of Array, readings
      refute_empty readings
      reading = readings.first
      assert_kind_of WaterGauges::Agencies::Models::Dwr::Reading, reading
      assert_equal 'DISCHRG', reading.parameter
    end
  end
end
