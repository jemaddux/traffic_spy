require 'traffic_spy'  # <-- your sinatra app
require 'rspec'
require 'rack/test'

# set :environment, :test

describe 'The Trafic Spy App' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "says hello" do
    get '/sources'
    last_response.should be_ok
    #last_response.body.should == 'Hello World'
  end

end
