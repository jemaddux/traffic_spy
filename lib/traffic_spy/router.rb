require 'sinatra'

module TrafficSpy
  class Router < Sinatra::Base
    set :views, "lib/traffic_spy/views"

    def self.hello_world
      "Hello World! works?"
    end

    get '/' do 
      "hello_wosdfasdfrld"
    end

    post "/sources/*/data" do
      #some array = params[:splat] ####is the * params as an array
      @identifier = params[:splat]
      parsed_data = JSON.parse(params[:payload], symbolize_names: true)
      parsed_data[:splat] = @identifier
      # raise parsed_data.inspect
      if parsed_data[:referredBy].nil?
        status 400
        "{\"message\":\"Bad Request\"}"
      else
        if Payload.already_exist?(parsed_data)
          status 403
          "{\"message\":\"Forbidden\"}"
        else
          Payload.add_to_database(parsed_data)
          status 200
        end
      end
    end

    get "/sources/:identifier" do
      #FakeData.make_fake_data
      if Identifier.not_exist?(params[:identifier])
        redirect to("/error") 
      else
        @urls = Payload.popular_urls_sorted(params[:identifier]).to_a
        # raise @urls.inspect
        @browsers = Payload.browsers(params[:identifier])
        @oses = Payload.oses(params[:identifier])
        @screen_resolutions = Payload.screen_resolution(params[:identifier])
        @average_response_times = Payload.response_times(params[:identifier])
        @events = Payload.events(params[:identifier])
        erb :identifier_stats_page
      end

    end

    get "/sources/*/urls/*" do
      if Payload.url_exist?(params[:splat])
        @sorted_response_times = Payload.sorted_url_response_times(params[:splat])
        erb :url_statistics
      else
        status 400
        "{\"message\":\"No url for identifier.\"}"
      end
    end

    get "/sources/:identifier/events" do
     if Payload.event_exist?(params[:identifier])
        @events = Payload.sorted_grouped_events(params[:identifier])
        erb :events
      else
        status 400
        "{\"message\":\"No events for identifier\"}"
      end
    end

    get "/sources/*/events/*" do
      if Payload.specific_event_exist?(params[:splat][0],params[:splat][1])
        @events = Payload.specific_events(params[:splat][0],params[:splat][1])
        erb :event_stats
      else
        erb :event_redirect
      end
    end

    post "/sources/:identifier/campaigns" do
      if params[:eventNames].nil? || params[:campaignName].nil?
        status 400
        "{\"message\":\"Bad request.\"}"
      elsif Campaigns.exist?(params)
        status 403
        "{\"message\":\"Forbidden.\"}"
      else
        Campaigns.add_to_database(params)
        status 200
        params.inspect
      end
    end

    get "/sources/:identifier/campaigns" do
      # Campaigns.database.where(identifier: params[:identifier]).to_a

      # a = Campaigns.does_exist?(params[:identifier])
      if Campaigns.does_exist?(params[:identifier])
        status 200
        @campaigns = Campaigns.list(params[:identifier])
        erb :campaign_index
      else
        status 200
       "{\"message\":\"No campaigns for identifier\"}"
      end
    end

    get "/sources/:identifier/campaigns/:campaignName" do
      if Campaigns.campaignName_exist?(params)
        @eventNames = EventNames.list(params)
        @payloads = []
        @eventNames.each do |eventName|
          @payloads += Payload.get_events(params[:identifier],eventName[:eventName]).to_a
        end
        @params = params
        erb :campaignName
      else
        "No campaign named #{params[:campaignName]} for #{params[:identifier]}. <a href='http://localhost:9393/sources/#{params[:identifier]}/campaigns'>#{params[:identifier]}</a>"
      end
    end

    get "/sources/:identifier/campaigns/:campaignName/:eventName" do
      @payloads = Payload.get_events(params[:identifier],params[:eventName])
      @params = params
      erb :specific_event
    end

    get '/error' do
      erb :identifier_error
    end

    post '/sources' do
      if params[:rootUrl].nil?
        status 400
        "{\"message\":\"no url provided\"}"
      elsif params[:identifier].nil?
        status 400
        "{\"message\":\"no identifier provided\"}"
      else
        if Identifier.already_exist?(params[:identifier])
          status 403        
          "{\"message\":\"Duplicate identifier.\"}"
        else
          Identifier.add_to_database(params)
          status 200
          "{\"identifier\":\"#{params[:identifier]}\"}" 
        end
      end
    end
  end
end
