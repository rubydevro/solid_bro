require_relative "lib/solid_bro/version"

Gem::Specification.new do |spec|
  spec.name        = "solid_bro"
  spec.version     = SolidBro::VERSION
  spec.authors     = [ "Emanuel Comsa" ]
  spec.email       = [ "office@rubydev.ro" ]
  spec.homepage    = "https://www.rubydev.ro"
  spec.summary     = "A web UI dashboard for managing SolidQueue jobs, queues, workers, and recurring tasks in Rails applications."
  spec.description = "A web UI dashboard for managing SolidQueue jobs, queues, workers, and recurring tasks in Rails applications."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/rubydevro/solid_bro"
  spec.metadata["changelog_uri"] = "https://github.com/rubydevro/solid_bro/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.0"
  spec.add_dependency "pagy", ">= 5.0"  # Supports Pagy 9.x, 8.x, and 43.x
  spec.add_dependency "solid_queue"

  spec.add_development_dependency "rspec-rails"
end
