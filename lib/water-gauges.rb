require "zeitwerk"
require "dry-configurable"
require "httparty"
require "json"

module WaterGauges
  # Set up autoloading
  loader = Zeitwerk::Loader.for_gem
  loader.setup

  # Include dry-configurable
  extend Dry::Configurable

  # Define settings
  setting :user_agent, default: -> { "WaterGauges Ruby Gem/#{VERSION}" }
  setting :timeout, default: 30
  setting :base_urls do
    setting :dwr, default: "https://dwr.state.co.us/Rest/GET/api/v2"
    setting :usgs, default: "https://waterservices.usgs.gov/nwis"
  end
  setting :default_parameters do
    setting :dwr, default: "DISCHRG"
    setting :usgs, default: "00060"
  end

  class << self
    def client(agency, **options)
      case agency
      when :dwr
        Agencies::Dwr::Client.new(**options)
      when :usgs
        Agencies::Usgs::Client.new(**options)
      else
        raise Errors::UnsupportedAgencyError, "Unsupported agency: #{agency}"
      end
    end
  end
end
