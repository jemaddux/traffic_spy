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

  get "/sources/*" do
    TrafficSpy::FakeData.make_fake_data
    if TrafficSpy::Identifier.not_exist?(params[:splat])
      redirect to("/error") 
    else
      @urls = TrafficSpy::Payload.popular_urls_sorted(params[:splat])
      @browsers = TrafficSpy::Payload.browsers(params[:splat])
      @oses = TrafficSpy::Payload.oses(params[:splat])
      @screen_resolutions = TrafficSpy::Payload.screen_resolution(params[:splat])
      @average_response_times = TrafficSpy::Payload.response_times(params[:splat])
      @events = TrafficSpy::Payload.events(params[:splat])
      erb :identifier_stats_page
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

















