require 'traffic_spy'
require 'rspec'
require 'rack/test'


# set :environment, :test

describe 'The Trafic Spy App' do
  include Rack::Test::Methods

  def app
    TrafficSpy::Application
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

    context "with rootURL but without identifier" do
      it "returns 400 with an error meesage" do
        post "/sources", :rootUrl => "http://jumpstartlab.com"
        last_response.status.should eq 400
        last_response.body.should eq "{\"message\":\"no identifier provided\"}"
      end
    end

    context "if identifier already exists" do
      it "returns 403 with an error message" do
        post "/sources", :identifier => "google", :rootUrl => "http://google.com"
        post "/sources", :identifier => "google", :rootUrl => "http://google.com"
        last_response.status.should eq 403
        last_response.body.should eq "{\"message\":\"Duplicate identifier.\"}"
      end
    end

    # context "with two identitical payloads" do
    #   it "returns 403 error with message" do
    #     payload = {
    #       :url => "http://jumpstartlab.com/blog",
    #       :requestedAt => "2013-02-16 21:38:28 -0700",
    #       :respondedIn => 37,
    #       :referredBy => "http://jumpstartlab.com",
    #       :requestType => "GET",
    #       :parameters => [],
    #       :eventName => "socialLogin",
    #       :userAgent => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
    #       :resolutionWidth => "1920",
    #       :resolutionHeight => "1280",
    #       :ip => "63.29.38.211" 
    #     } 
    #     post "/sourc9q3845098305480es", payload
    #     post "/sources", payload
    #     last_response.status.should eq 403
    #     last_response.body.should eq "{\"message\":\"Forbidden - duplicate payload\"}"
    #   end
    # end
  end



end
