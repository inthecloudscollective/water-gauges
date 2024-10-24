module WaterGauges
  module Agencies
    class BaseClient
      include HTTParty

      attr_reader :options

      def initialize(**options)
        @options = options
        setup_client
      end

      private

      def setup_client
        self.class.default_timeout(WaterGauges.config.timeout)
        self.class.headers({
          'User-Agent' => WaterGauges.config.user_agent
        })
      end
    end
  end
end
