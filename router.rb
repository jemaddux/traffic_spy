Bundler.require
require 'sinatra/base'
#require 'sinatra/reloader'
require 'traffic_spy'
require 'erb'

class Router < Sinatra::Base
  def self.hello_world
    "Hello World! works?"
  end

  get '/' do 
    "hello_wosdfasdfrld"
  end

  post "/sources/*/data" do
    #some array = params[:splat] ####is the * params as an array
    if params[:referredBy].nil?
      status 400
      "{\"message\":\"Bad Request\"}"
    else
      if TrafficSpy::Payload.already_exist?(params)
        status 403
        "{\"message\":\"Forbidden\"}"
      else
        TrafficSpy::Payload.add_to_database(params)
        status 200
      end
    end
  end

  get "/sources/:identifier" do
    TrafficSpy::FakeData.make_fake_data
    if TrafficSpy::Identifier.not_exist?(params[:identifier])
      redirect to("/error") 
    else
      @urls = TrafficSpy::Payload.popular_urls_sorted(params[:identifier])
      @browsers = TrafficSpy::Payload.browsers(params[:identifier])
      @oses = TrafficSpy::Payload.oses(params[:identifier])
      @screen_resolutions = TrafficSpy::Payload.screen_resolution(params[:identifier])
      @average_response_times = TrafficSpy::Payload.response_times(params[:identifier])
      @events = TrafficSpy::Payload.events(params[:identifier])
      erb :identifier_stats_page
    end

  end

  get "/sources/*/urls/*" do
    if TrafficSpy::Payload.url_exist?(params[:splat])
      @sorted_response_times = TrafficSpy::Payload.sorted_url_response_times(params[:splat])
      erb :url_statistics
    else
      status 400
      "{\"message\":\"No url for identifier.\"}"
    end
  end

  get "/sources/*/events" do
   if TrafficSpy::Payload.event_exist?(params[:splat])
      @events = TrafficSpy::Payload.sorted_grouped_events(params[:splat])
      erb :events
    else
      status 400
      "{\"message\":\"No events for identifier\"}"
    end
  end

  get "/sources/*/events/*" do
    if TrafficSpy::Payload.specific_event_exist?(params[:splat][0],params[:splat][1])
      @events = TrafficSpy::Payload.specific_events(params[:splat][0],params[:splat][1])
      erb :event_stats
    else
      erb :event_redirect
    end
  end

  post "/sources/:identifier/campaigns" do
    if params[:eventNames].nil? || params[:campaignName].nil?
      status 400
      "{\"message\":\"Bad request.\"}"
    elsif TrafficSpy::Campaigns.exist?(params)
      status 403
      "{\"message\":\"Forbidden.\"}"
    else
      TrafficSpy::Campaigns.add_to_database(params)
      status 200
      params.inspect
    end
  end

  get "/sources/:identifier/campaigns" do
    a =  TrafficSpy::DB[:campaigns].where(identifier: params[:identifier]).to_a
    raise a.inspect
    a = TrafficSpy::Campaigns.does_exist?(params[:identifier])
    raise a.inspect
    if TrafficSpy::Campaigns.does_exist?(params[:identifier])
      status 200
      erb :campaign_index
      #return page of links
    else
      status 200
     "{\"message\":\"No campaigns for identifier\"}"
    end
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
      if TrafficSpy::Identifier.already_exist?(params[:identifier])
        status 403        
        "{\"message\":\"Duplicate identifier.\"}"
      else
        TrafficSpy::Identifier.add_to_database(params)
        status 200
        "{\"identifier\":\"#{params[:identifier]}\"}" 
      end
    end
  end

  run!
end

















