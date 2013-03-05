Bundler.require
require './lib/traffic_spy'

app = TrafficSpy::Server
run app
