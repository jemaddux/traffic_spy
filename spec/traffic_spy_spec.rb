require 'traffic_spy'
require 'rspec'
require 'rack/test'


# set :environment, :test

describe 'The Trafic Spy App' do
  include Rack::Test::Methods

  def app
    TrafficSpy::Application
  end


end
