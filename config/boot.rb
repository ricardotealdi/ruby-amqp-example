require 'logger'

module AmqpExample
  APP_NAME            = 'amqp-example'
  DEFAULT_ENVIRONMENT = 'development'
  APP_ROOT            = ::File.expand_path('../..', __FILE__)
  CONFIG_ROOT         = ::File.expand_path('config', APP_ROOT)
  LIB_DIR             = ::File.expand_path("lib/#{APP_NAME}", APP_ROOT)
  RICQUE_VERSION      = '0.1.3'

  def self.app_name
    APP_NAME
  end

  def self.lib_dir
    LIB_DIR
  end

  def self.config_dir
    CONFIG_ROOT
  end

  def self.config_dir= config_dir
    CONFIG_ROOT
  end
  
  def self.root
    APP_ROOT
  end

  def self.env
    ENV["RUBY_ENV"]
  end

  def self.groups
    ENV["BUNDLER_GROUPS"].split(',')
  end

  def self.configuration
    @@config ||= {}
    @@config
  end

  def self.logger= logger
    configuration[:logger] = logger
  end

  def self.logger
    configuration[:logger] ||= Logger.new(STDOUT)
  end

  def self.logger?
    !configuration[:logger].nil?
  end

  def self.development?
    ENV["RUBY_ENV"] == "development"
  end
end

ENV["RUBY_ENV"] = ENV["RUBY_ENV"] || ENV["RACK_ENV"] || AmqpExample::DEFAULT_ENVIRONMENT
ENV["RACK_ENV"] = ENV["RUBY_ENV"]

ENV["BUNDLER_GROUPS"] = "default,#{ENV["RUBY_ENV"]}"

require 'rubygems'
require 'bundler/setup'

Bundler.require(*ENV["BUNDLER_GROUPS"].split(','))
