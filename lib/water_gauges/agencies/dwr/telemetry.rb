module WaterGauges
  module Agencies
    module Dwr
      module Telemetry

        def get_stations
          response = self.class.get("/telemetrystations/telemetrystation/", {
            query: {
              format: 'json',
            }
          })

          data = handle_response(response)
          Parser.parse_stations(data)
        end

        def get_station(station_id)
          response = self.class.get("/telemetrystations/telemetrystation/", {
            query: {
              format: 'json',
              abbrev: station_id,
              parameter: WaterGauges.config.default_parameters.dwr
            }
          })

          data = handle_response(response)
          Parser.parse_station(data)
        end

        def get_telemetry_stations(aoi: nil, radius: nil, abbrev: nil, county: nil, division: nil, gnis_id: nil, usgs_id: nil, water_district: nil, wdid: nil)
          query = {
            format: 'json',
            dateFormat: 'spaceSepToSeconds',
            includeThirdParty: true
          }

          query[:abbrev] = abbrev if abbrev
          query[:county] = county if county
          query[:division] = division if division
          query[:gnisId] = gnis_id if gnis_id
          query[:usgsStationId] = usgs_id if usgs_id
          query[:waterDistrict] = water_district if water_district
          query[:wdid] = wdid if wdid

          if aoi
            # Assuming aoi is a hash with :latitude and :longitude
            if aoi.is_a?(Hash) && aoi[:latitude] && aoi[:longitude]
              query[:latitude] = aoi[:latitude]
              query[:longitude] = aoi[:longitude]
            else
              raise ArgumentError, "Invalid 'aoi' parameter"
            end
            query[:radius] = radius || 20
            query[:units] = 'miles'
          end

          page_size = 50000
          page_index = 1
          results = []

          loop do
            query[:pageSize] = page_size
            query[:pageIndex] = page_index

            response = self.class.get("/telemetrystations/telemetrystation/", {
              query: query
            })

            data = handle_response(response)
            stations = Parser.parse_stations(data)

            break if stations.empty?

            results.concat(stations)

            break if stations.size < page_size

            page_index += 1
          end

          results
        end

        def get_telemetry_ts(abbrev:, parameter: 'DISCHRG', start_date: nil, end_date: nil, timescale: 'day', include_third_party: true)
          timescales = ['day', 'hour', 'raw']
          unless timescales.include?(timescale)
            raise ArgumentError, "Invalid 'timescale' argument: '#{timescale}'. Valid values are: #{timescales.join(', ')}"
          end

          query = {
            format: 'json',
            dateFormat: 'spaceSepToSeconds',
            abbrev: abbrev,
            parameter: parameter,
            includeThirdParty: include_third_party.to_s
          }

          query[:startDate] = start_date.strftime('%m-%d-%Y') if start_date
          query[:endDate] = end_date.strftime('%m-%d-%Y') if end_date

          page_size = 50000
          page_index = 1
          results = []

          loop do
            query[:pageSize] = page_size
            query[:pageIndex] = page_index

            response = self.class.get("/telemetrystations/telemetrytimeseries#{timescale}/", {
              query: query
            })

            data = handle_response(response)
            readings = Parser.parse_readings(data)

            break if readings.empty?

            results.concat(readings)

            break if readings.size < page_size

            page_index += 1
          end

          results
        end
      end
    end
  end
end
