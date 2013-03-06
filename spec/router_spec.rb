require 'spec_helper'

describe 'router.rb' do
  include Rack::Test::Methods

  def app
    TrafficSpy::Router
  end

  before(:each) do
    TrafficSpy::DatabaseConnection.delete_all
  end

  describe "router class" do
    context "self.hello_world" do

      it "responds to get '/' " do
        get '/'
        last_response.status.should eq 200
      end
    end

    let(:payload) do
      payload = %Q{
        {"url":"http://jumpstartlab.com/blog",
          "requestedAt":"2013-02-16 21:38:28 -0700",
          "respondedIn":37,
          "referredBy":"http://jumpstartlab.com",
          "requestType":"GET",
          "parameters":[],
          "eventName": "socialLogin",
          "userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
          "resolutionWidth":"1920",
          "resolutionHeight":"1280",
          "ip":"63.29.38.211"}
      }
      payload.gsub("\n", "").gsub(/\s\s+/, "")
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
        url = "http://jumpstartlab.com"
        TrafficSpy::Identifier.
          add_to_database(identifier: 'jumpstartlab', rootUrl: url)
        post "/sources/jumpstartlab/data", {payload: payload}
        last_response.status.should eq 200
      end
    
      it "returns 200 OK" do
        payload_google = 'payload={"url":"http://jumpstartlab.com/blog","requestedAt":"2013-02-16 21:38:28 -0700","respondedIn":37,"referredBy":"http://jumpstartlab.com","requestType":"GET","parameters":[],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211"}'
        post "/sources/google/data", payload_google
        last_response.status.should eq 200
      end

      it "returns 400 Bad Request" do
        payload_bad = 'payload={"requestedAt":"2013-02-16 21:38:28 -0700","respondedIn":37,"requestType":"GET","parameters":[],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211"}'
        post "/sources/google/data", payload_bad
        last_response.status.should eq 400
        last_response.body.should eq "{\"message\":\"Bad Request\"}"
      end

      it "returns 403 Forbidden" do
        payload = 'payload={"url":"http://jumpstartlab2.com/blog","requestedAt":"2013-02-16 21:38:28 -0700","respondedIn":37,"referredBy":"http://jumpstartlab.com","requestType":"GET","parameters":[],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211"}'
        post "/sources/amazon/data", payload
        post "/sources/amazon/data", payload
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
      end
    end
  end

  describe "POST /sources" do
    context "with both identifier and rootUrl" do
      it "returns a 200(OK) with a body" do
        post "/sources", :identifier => 'jumpstartlab2', :rootUrl => 'http://jumpstartlab2.com'
        last_response.status.should eq 200
        last_response.body.should eq "{\"identifier\":\"jumpstartlab2\"}"
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

  describe "GET sources/IDENTIFIER/urls/RELATIVE/PATH" do
    let(:payload) do
      payload = %Q{
        {"url":"http://jumpstartlab.com/blog",
          "requestedAt":"2013-02-16 21:38:28 -0700",
          "respondedIn":37,
          "referredBy":"http://jumpstartlab.com",
          "requestType":"GET",
          "parameters":[],
          "eventName": "socialLogin",
          "userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
          "resolutionWidth":"1920",
          "resolutionHeight":"1280",
          "ip":"63.29.38.211"}
      }
      payload.gsub("\n", "").gsub(/\s\s+/, "")
    end

    context 'if URL for IDENTITFIER exists' do
      it "should return a page with response times" do
        pending
        post "/sources", :identifier => "jumpstartlab", :rootUrl => 'http://jumpstartlab.com'
        post "/sources/jumpstartlab/data", payload
        get "sources/jumpstartlab/urls/blog"
        last_response.status.should eq 200
        #last_response.body.should eq "html"
      end
    end

    context "if URL for IDENTITFIER doesn't exist" do
      it "should return a message that the url hasn't been requested" do
        get "sources/bing/urls/not_searching_for_stuff"
        last_response.status.should eq 400
        last_response.body.should eq "{\"message\":\"No url for identifier.\"}"
      end
    end
  end

  describe "GETS sources/IDENTIFIER/events" do
    let(:payload) do
      payload = %Q{
        {"url":"http://jumpstartlab.com/blog",
          "requestedAt":"2013-02-16 21:38:28 -0700",
          "respondedIn":37,
          "referredBy":"http://jumpstartlab.com",
          "requestType":"GET",
          "parameters":[],
          "eventName": "socialLogin",
          "userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
          "resolutionWidth":"1920",
          "resolutionHeight":"1280",
          "ip":"63.29.38.211"}
      }
      payload.gsub("\n", "").gsub(/\s\s+/, "")
    end

    context "if event already exists" do
      it "returns a page with event details" do
        pending
        post "/sources", :identifier => "jumpstartlab", :rootUrl => 'http://jumpstartlab.com'
        post "/sources/jumpstartlab/data", payload
        get "/sources/jumpstartlab/events"
        last_response.status.should eq 200
        last_response.body.should eq "{\"message\":\"No sadfsdevents for identifier\"}"
      end
    end

    context "if event doesnt exist" do
      it "returns an error message" do
        post "/sources", :identifier => "toyota", :rootUrl => 'http://www.toyota.com'
        get "sources/toyota/events"
        last_response.status.should eq 400
        last_response.body.should eq "{\"message\":\"No events for identifier\"}"
      end
    end
  end

  describe "GETS sources/IDENTIFIER/events/EVENTNAME" do
    context "if event already exists" do
      it "returns a page of event specific data" do
        get "sources/zappos/events/searchFind"
        last_response.status.should eq 200
      end
    end

    context "if event doesnt exist" do
      it "returns a page with redirect event index & error message" do
        post "/sources", :identifier => "toyota", :rootUrl => 'http://www.toyota.com'
        get "sources/toyota/events/toyotathon"
        last_response.status.should eq 200
      end
    end    
  end

  describe "POST sources/IDENTIFIER/campaigns" do
    context "if campaign name already exists" do
      it "should return a 403 Forbidden error message" do
        post "/sources", :identifier => "blizzard", :rootUrl => 'http://blizard.com'
        post "/sources/blizzard/campaigns", :campaignName => "diablo", :eventNames => ["internet_portal", "gaming"]
        post "/sources/blizzard/campaigns", :campaignName => "diablo", :eventNames => ["internet_portal", "gaming"]
        last_response.status.should eq 403
        last_response.body.should eq "{\"message\":\"Forbidden.\"}"
      end
    end

    context "if missing any parameters" do
      it "should return a 400 Bad Request when missing events" do
        post "/sources", :identifier => "junkfood", :rootUrl => 'http://junkfood.com'
        post "/sources/junkfood/campaigns", :campaignName => "cheese-its"
        last_response.status.should eq 400
        last_response.body.should eq "{\"message\":\"Bad request.\"}"
      end

      it "should return a 400 Bad Request when missing campaignName" do
        post "/sources", :identifier => "goodfood", :rootUrl => 'http://goodfood.com'
        post "/sources/goodfood/campaigns", :eventNames => ["apples","strawberries"]
        last_response.status.should eq 400
        last_response.body.should eq "{\"message\":\"Bad request.\"}"
      end
    end

    context "if POST request is good" do
      it "should return a status 200" do
        post "/sources", :identifier => "pixar", :rootUrl => 'http://pixar.com'
        post "/sources/pixar/campaigns", :campaignName => "wall-e", :eventNames => ["recycle", "eve"]
        last_response.status.should eq 200
      end
    end
  end



end












