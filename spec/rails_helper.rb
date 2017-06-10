# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)

# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'spec_helper'
require 'rspec/rails'
require 'support/factory_girl'

ActiveRecord::Base.logger.level = 1
ActiveRecord::Migration.maintain_test_schema!

Capybara.javascript_driver = :webkit
Monban.test_mode!

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.include Monban::Test::Helpers, type: :feature

  config.after :each do
    Monban.test_reset!
  end
end
