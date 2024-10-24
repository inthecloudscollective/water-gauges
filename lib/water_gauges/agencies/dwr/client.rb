module WaterGauges
  module Agencies
    module Dwr
      class Client < BaseClient
        base_uri WaterGauges.config.base_urls.dwr

        def get_stations
          response = self.class.get("/telemetrystations/telemetrystation/", {
            query: {
              format: 'json',
            }
          })

          handle_response(response)
        end

        def get_station(station_id)
          response = self.class.get("/telemetrystations/telemetrystation/", {
            query: {
              format: 'json',
              abbrev: station_id,
              parameter: WaterGauges.config.default_parameters.dwr
            }
          })

          Parser.parse_station(handle_response(response))
        end
      end
    end
  end
end
