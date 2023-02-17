ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'simplecov'

SimpleCov.start 'rails' do
  # any custom configs
end

require 'rails/test_help'
class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  # Add more helper methods to be used by all tests here...
end