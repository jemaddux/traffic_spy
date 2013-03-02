require 'sequel'
require 'sinatra/base'
require 'traffic_spy/identifiers'
require 'traffic_spy/payload'

module TrafficSpy
  class Application < Sinatra::Base
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

    post "/sources/*/data" do
      #some array = params[:splat] ####is the * params as an array
      if params[:referredBy].nil?
        status 400
        "{\"message\":\"Bad Request\"}"
      else
        if Payload.already_exist?(params)
          status 403
          "{\"message\":\"Forbidden\"}"
        else
          Payload.add_to_database(params)
          status 200
        end
      end
    end

    get "/sources/*" do
      if Identifier.not_exist?(params[:splat])
        redirect to("/error") 
      else

      end
    end

    get '/error' do
      erb :identifier_error
      status 200
    end

    get '/' do
      "Hello World"
    end

  end

end

