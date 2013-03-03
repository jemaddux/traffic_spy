require 'rspec'
require 'rack/test'
require './router'

describe 'router.rb' do
  include Rack::Test::Methods

  def app
    Router
  end

  describe "router class" do
    context "self.hello_world" do
      it "returns 'Hello Word!'" do
        response = Router.hello_world
        response.should eq "Hello World! works?"
      end

      it "responds to get '/' " do
        get '/'
        last_response.status.should eq 200
      end
    end

    let(:payload) do
      payload = {
          :url => "http://jumpstartlab.com/blog",
          :requestedAt => "2013-02-16 21:38:28 -0700",
          :respondedIn => 37,
          :referredBy => "http://jumpstartlab.com",
          :requestType => "GET",
          :parameters => [],
          :eventName => "socialLogin",
          :userAgent => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
          :resolutionWidth => "1920",
          :resolutionHeight => "1280",
          :ip => "63.29.38.211" 
        }
    end

    let(:payload_google) do
      payload = {
          :url => "http://www.google.com/blog",
          :requestedAt => "2013-02-16 21:38:28 -0700",
          :respondedIn => 37,
          :referredBy => "http://www.google.com",
          :requestType => "GET",
          :parameters => [],
          :eventName => "socialLogin",
          :userAgent => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
          :resolutionWidth => "1920",
          :resolutionHeight => "1280",
          :ip => "63.29.38.211" 
        }
    end


    let(:payload_amazon) do
      payload = {
          :url => "http://www.amazon.com/blog",
          :requestedAt => "2013-02-16 21:38:28 -0700",
          :respondedIn => 37,
          :referredBy => "http://www.amazon.com",
          :requestType => "GET",
          :parameters => [],
          :eventName => "socialLogin",
          :userAgent => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
          :resolutionWidth => "1920",
          :resolutionHeight => "1280",
          :ip => "63.29.38.211" 
        }
    end

    context "respond to a payload" do
      it "returns 200 OK" do
         post "/sources/jumpstartlab/data", payload
         #Router.sources_identifier_data(payload)
         last_response.status.should eq 200
      end
    
      it "returns 200 OK" do
         post "/sources/google/data", payload_google
         last_response.status.should eq 200
      end

      it "returns 400 Bad Request" do
        payload_bad = {}
        post "/sources/google/data", payload_bad
        last_response.status.should eq 400
        last_response.body.should eq "{\"message\":\"Bad Request\"}"
      end

      it "returns 403 Forbidden" do
        post "/sources/amazon/data", payload_amazon
        post "/sources/amazon/data", payload_amazon
        last_response.status.should eq 403
        last_response.body.should eq "{\"message\":\"Forbidden\"}"
      end        
    end

    context "responding to sources/IDENTITFIER" do
      it "with a bad IDENTITFIER we get redirected to another page" do
        get "/sources/apple"
        follow_redirect!
        last_response.status.should eq 200
      end

      it "does exists we get a page" do
        payload_bing1 = {
          :url => "http://www.bing.com/blog",
          :requestedAt => "2013-02-16 22:38:28 -0700",
          :respondedIn => 37,
          :referredBy => "http://www.bing.com",
          :requestType => "GET",
          :parameters => [],
          :eventName => "socialLogin",
          :userAgent => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
          :resolutionWidth => "1920",
          :resolutionHeight => "1280",
          :ip => "63.29.38.211" 
        }

        payload_bing2 = {
          :url => "http://www.bing.com",
          :requestedAt => "2013-03-16 22:38:28 -0700",
          :respondedIn => 37,
          :referredBy => "http://www.bing.com",
          :requestType => "GET",
          :parameters => [],
          :eventName => "frontPage",
          :userAgent => "Opera/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
          :resolutionWidth => "1920",
          :resolutionHeight => "1080",
          :ip => "63.39.38.213" 
        }

        post "/sources", :identifier => "bing", :rootUrl => 'http://www.bing.com'
        post "/sources/bing/data", payload_bing1
        post "/sources/bing/data", payload_bing2

        get "sources/bing"
        last_response.status.should eq 200
        last_response.body.should eq "html"
        last_response.location.should include 'bing'
        ##have bunches of stuff
      end
    end
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
  end
end
