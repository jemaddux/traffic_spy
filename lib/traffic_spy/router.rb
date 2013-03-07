require 'sinatra'

module TrafficSpy
  class Router < Sinatra::Base
    set :views, "lib/traffic_spy/views"

    get '/' do
      "Hello World"
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

    post "/sources/:identifier/data" do
      parsed_data = JSON.parse(params[:payload], symbolize_names: true)
      parsed_data[:identifier] = params[:identifier]
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
      if Identifier.not_exist?(params[:identifier])
        redirect to("/error")
      else
        @urls = Payload.popular_urls_sorted(params[:identifier]).to_a.uniq{|url| url[:url]}
        @urls.each do |url|
          url[:count] = Payload.how_many_urls(url)
          url[:longest] = Payload.url_time_long(url)
          url[:shortest] = Payload.url_time_short(url)
          url[:avg] = Payload.url_time_avg(url)
        end
        @urls = @urls.sort_by{|url| url[:count]}.reverse
        @browsers = Payload.browsers(params[:identifier]).to_a.uniq{|brw| brw[:userAgent]}
        @browsers.each do |brw|
          ua = AgentOrange::UserAgent.new(brw[:userAgent])
          brw[:browser] = ua.device.engine.browser
          brw[:os] = ua.device.operating_system
          brw[:count] = Payload.how_many_browser_visits(brw)
        end
        @screen_resolutions = Payload.screen_resolution(params[:identifier]).to_a.uniq{|screen| screen[:resolutionWidth]}

        @events = Payload.events(params[:identifier]).to_a.uniq{|event| event[:eventName]}
        @params = params
        erb :identifier_stats_page
      end

    end

    get "/sources/:identifier/urls/:path" do
      if Payload.url_exist(params[:identifier],params[:path])
        @urls = Payload.urls(params[:identifier],params[:path]).to_a.sort_by{|url| url[:respondedIn].to_i}.reverse
        status 200
        erb :url_statistics
      else
        status 400
        "{\"message\":\"No url for identifier.\"}"
      end
    end

    get "/sources/:identifier/events" do
     if Payload.event_exist?(params[:identifier])
        @params = params
        @events = Payload.sorted_grouped_events(params[:identifier]).to_a.uniq{|event| event[:eventName]}.sort_by{|event| event[:count]}.reverse
        erb :events
      else
        status 400
        "{\"message\":\"No events for identifier\"}"
      end
    end

    get "/sources/:identifier/events/:eventName" do
      if Payload.specific_event_exist?(params[:identifier],params[:eventName])
        @events = Payload.specific_events(params[:identifier],params[:eventName]).to_a.uniq{|event| event[:hour]}.sort_by{|event| event[:hour]}
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
      if Campaigns.does_exist?(params[:identifier])
        status 200
        @params = params
        @campaigns = Campaigns.list(params[:identifier])
        erb :campaign_index
      else
        status 200
       "{\"message\":\"No campaigns for identifier\"}"
      end
    end

    get "/sources/:identifier/campaigns/:campaignName" do
      if Campaigns.campaignName_exist?(params)
        @eventNames = EventNames.list(params).to_a
        @eventNames.each do |event|
          event[:count] = Payload.how_many_event_names(event)
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


  end
end
