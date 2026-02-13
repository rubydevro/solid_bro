ENV["RAILS_ENV"] ||= "test"

require File.expand_path("../test/dummy/config/environment", __dir__)

abort("The Rails environment is running in #{Rails.env} mode!") unless Rails.env.test?

require "rspec/rails"

RSpec.configure do |config|
  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end

require_relative "spec_helper"


