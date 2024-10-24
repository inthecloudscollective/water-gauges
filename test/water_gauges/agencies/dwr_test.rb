require "test_helper"

class WaterGauges::Agencies::DwrTest < Minitest::Test
  def setup
    @client = WaterGauges.client(:dwr)
  end

  def test_fetches_station_data
    VCR.use_cassette("dwr_station") do
      station = @client.get_station("PLAHARCO")
      refute_nil station
      assert_equal "PLAHARCO", station.id
    end
  end
end
