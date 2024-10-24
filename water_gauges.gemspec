# frozen_string_literal: true

require_relative "lib/water_gauges/version"

Gem::Specification.new do |spec|
  spec.name = "water_gauges"
  spec.version = WaterGauges::VERSION
  spec.authors = ["Matt Michnal "]
  spec.email = ["mattm3646@gmail.com"]

  spec.summary       = "Ruby wrapper for various water resource APIs"
  spec.description   = "Access water station data from USGS, Colorado DWR, TWDB, and other water agencies"
  spec.homepage      = "https://github.com/mgm702/water_gauges"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/mgm702/water_gauges"
  spec.metadata["changelog_uri"] = "https://github.com/mgm702/water_gauges/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "httparty", "~> 0.21.0"
  spec.add_dependency "dry-configurable", "~> 1.0"
  spec.add_dependency "zeitwerk", "~> 2.6"

  # Development dependencies
  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "minitest-reporters", "~> 1.5"
  spec.add_development_dependency "webmock", "~> 3.18"
  spec.add_development_dependency "vcr", "~> 6.0"
end
