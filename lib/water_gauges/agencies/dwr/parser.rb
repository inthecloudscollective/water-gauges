module WaterGauges
  module Agencies
    module Dwr
      class Parser
        class << self
          # Convert DWR station response to standardized Station object
          def parse_station(response)
            return nil unless response["ResultList"]&.first

            data = response["ResultList"].first
            Models::Station.new(
              id: data["abbrev"],
              name: data["stationName"],
              agency: "DWR",
              latitude: data["latitude"],
              longitude: data["longitude"],
              parameters: extract_parameters(data),
              metadata: {
                county: data["county"],
                division: data["division"],
                water_source: data["waterSource"],
                usgs_id: data["usgsStationId"],
                status: data["stationStatus"],
                por_start: data["stationPorStart"],
                por_end: data["stationPorEnd"]
              }
            )
          end

          # Convert DWR readings response to standardized Reading objects
          def parse_readings(response)
            return [] unless response["ResultList"]

            response["ResultList"].map do |reading|
              Models::Reading.new(
                timestamp: parse_timestamp(reading["measDateTime"]),
                value: reading["measValue"].to_f,
                unit: reading["units"],
                parameter: reading["parameter"],
                quality: reading["flagA"],
                metadata: {
                  stage: reading["stage"],
                  flag_b: reading["flagB"]
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

          def extract_parameters(data)
            # DWR typically provides parameters in the station data
            # This is a simplified version - you might want to expand based on actual data
            ["DISCHRG", "GAGE_HT"].select do |param|
              data[param.downcase]
            end
          end
        end
      end

      # Example of parameter mappings
      PARAMETER_MAPPINGS = {
        "DISCHRG" => {
          name: "Discharge",
          unit: "CFS",
          description: "Streamflow discharge in cubic feet per second"
        },
        "GAGE_HT" => {
          name: "Gage Height",
          unit: "ft",
          description: "Water level above datum in feet"
        }
      }.freeze
    end
  end
end
