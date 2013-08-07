ENV["RUBY_ENV"] = ENV["RACK_ENV"] = 'test'

require 'simplecov'
require 'simplecov-rcov'
SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
SimpleCov.start 'rails' do
  add_filter "/spec/"
end

require File.expand_path("../../config/environment", __FILE__)

require 'rspec/autorun'
# require 'factory_girl'
# require 'database_cleaner'

Dir["#{AmqpExample.root}/spec/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|

  # config.include FactoryGirl::Syntax::Methods

  # config.before(:suite) do
  # end

  # config.after(:each) do
  # end

  config.order = "random"
end
