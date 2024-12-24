require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
require "factory_bot_rails"
require "database_cleaner/active_record"
require 'mock_redis'

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = false
  config.render_views = false

  # DatabaseCleaner configuration
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  # Mock Redis setup
  config.before(:each) do
    mock_redis_instance = MockRedis.new
    $redis = mock_redis_instance
  end  
  
  # Disable view rendering for controller specs
  config.before(:each, type: :controller) do
    allow(controller).to receive(:render).and_return(nil)
  end

  # Infer spec types
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end
