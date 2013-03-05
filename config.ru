Bundler.require
require './lib/traffic_spy'

app = TrafficSpy::Router
run app
