Bundler.require
require 'traffic_spy'
require 'capybara/rspec'
require 'simplecov'
require 'rack/test'
SimpleCov.start

TrafficSpy::DatabaseConnection.database_for(:test)
