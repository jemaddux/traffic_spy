require 'sequel'
require 'sinatra/base'
require 'traffic_spy/identifiers'

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
  end
end

