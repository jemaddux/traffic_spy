require "traffic_spy/version"
require 'sinatra'

post '/sources' do
  if params[:rootUrl].nil?
    status 400
    "{\"message\":\"no url provided\"}"
  else
    "{\"identifier\":\"#{params[:identifier]}\"}"
  end
end

module TrafficSpy
  # Your code goes here...
end
