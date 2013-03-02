Bundler.require
require 'sinatra'
require 'traffic_spy'

get '/' do 
  "Hello World from Traffic Spy application"
end

get "/create" do
  "Hello World from the /create post"
end

get "/hobbits" do
  x = TrafficSpy::Identifier.testing
  "Hi #{x}"
end
