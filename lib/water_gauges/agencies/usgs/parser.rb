module WaterGauges
  module Usgs
    class Parser
      class << self
        # Convert USGS site response to standardized Station object
        def parse_station(response)
          return nil unless response.dig("value", "timeSeries", 0, "sourceInfo", "siteCode", 0)

          site_info = response["value"]["timeSeries"][0]["sourceInfo"]
          Models::Station.new(
            id: site_info["siteCode"][0]["value"],
            name: site_info["siteName"],
            agency: "USGS",
            latitude: site_info.dig("geoLocation", "geogLocation", "latitude"),
            longitude: site_info.dig("geoLocation", "geogLocation", "longitude"),
            parameters: extract_parameters(response),
            metadata: {
              site_type: site_info["siteType"],
              agency_code: site_info["siteCode"][0]["agencyCode"],
              time_zone: site_info["timeZoneInfo"]["defaultTimeZone"]["zoneAbbreviation"]
            }
          )
        end

        # Convert USGS value response to standardized Reading objects
        def parse_readings(response)
          time_series = response.dig("value", "timeSeries", 0)
          return [] unless time_series

          values = time_series.dig("values", 0, "value") || []
          variable = time_series["variable"]

          values.map do |reading|
            Models::Reading.new(
              timestamp: parse_timestamp(reading["dateTime"]),
              value: reading["value"].to_f,
              unit: variable.dig("unit", "unitCode"),
              parameter: variable["variableCode"][0]["value"],
              quality: reading["qualifiers"]&.join(","),
              metadata: {
                time_zone: reading["timeZone"]
              }
            )
          end
        end

        private

        def parse_timestamp(datetime_str)
          Time.parse(datetime_str)
        rescue
          nil
        end

        def extract_parameters(response)
          time_series = response.dig("value", "timeSeries") || []
          time_series.map { |ts| ts.dig("variable", "variableCode", 0, "value") }.compact
        end
      end
    end

    # Example of parameter mappings
    PARAMETER_MAPPINGS = {
      "00060" => {
        name: "Discharge",
        unit: "ft3/s",
        description: "Discharge, cubic feet per second"
      },
      "00065" => {
        name: "Gage height",
        unit: "ft",
        description: "Gage height, feet"
      }
    }.freeze
  end
end
