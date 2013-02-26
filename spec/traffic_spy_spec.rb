require 'traffic_spy'  # <-- your sinatra app
require 'rspec'
require 'rack/test'

# set :environment, :test

describe 'The Trafic Spy App' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  describe "POST /sources" do
    context "with both identifier and rootUrl" do
      it "returns a 200(OK) with a body" do
        post "/sources", :identifier => "jumpstartlab", :rootUrl => 'http://jumpstartlab.com'

        last_response.should be_ok
        last_response.body.should eq "{\"identifier\":\"jumpstartlab\"}"
      end
    end

    context "with indentifier but without rootURL" do
      it "returns 400 with an error meesage" do
        post "/sources", :identifier => "jumpstartlab"
        last_response.status.should eq 400
        last_response.body.should eq "{\"message\":\"no url provided\"}"
      end
    end
  end



end
