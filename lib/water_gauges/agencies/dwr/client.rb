require_relative 'telemetry'

module WaterGauges
  module Agencies
    module Dwr
      class Client < BaseClient
        base_uri WaterGauges.config.base_urls.dwr

        include Telemetry

        private

        # Handle API responses
        def handle_response(response)
          if response.success?
            JSON.parse(response.body)
          else
            raise Errors::APIError, "API request failed with status #{response.code}: #{response.message}"
          end
        end
      end
    end
  end
end
