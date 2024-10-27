module WaterGauges
  module Agencies
    module Models
      module Dwr
        class Reading
          attr_accessor :timestamp, :value, :unit, :parameter, :quality, :metadata

          def initialize(timestamp:, value:, unit:, parameter:, quality:, metadata: {})
            @timestamp = timestamp
            @value = value
            @unit = unit
            @parameter = parameter
            @quality = quality
            @metadata = metadata
          end
        end
      end
    end
  end
end
