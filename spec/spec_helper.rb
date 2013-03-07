Bundler.require
require 'simplecov'
SimpleCov.start
require 'traffic_spy'
require 'capybara/rspec'
require 'rack/test'


TrafficSpy::DatabaseConnection.database_for(:test)
