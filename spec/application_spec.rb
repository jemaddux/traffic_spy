require 'traffic_spy'
require 'traffic_spy/application'
require 'rspec'
require 'rack/test'

describe 'The Application.rb' do
  include Rack::Test::Methods

  def app
    TrafficSpy::Application
  end

  describe "POST /sources/IDENTITFIER/data" do
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
        last_response.body.type.should be html
        ##have bunches of stuff
      end

    end

    # When an identifer exists return a page that displays the following:

    # Most requested URLS to least requested URLS (url)
    # Web browser breakdown across all requests (userAgent)
    # OS breakdown across all requests (userAgent)
    # Screen Resolution across all requests (resolutionWidth x resolutionHeight)
    # Longest, average response time per URL to shortest, average response time per URL
    # Hyperlinks of each url to view url specific data
    # Hyperlink to view aggregate event data




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
