current_path = File.expand_path('lib')
$LOAD_PATH.push(current_path) unless $LOAD_PATH.include?($LOAD_PATH)
Bundler.require

require 'traffic_spy'
<<<<<<< HEAD
run TrafficSpy::Router
=======
run TrafficSpy::Server
>>>>>>> 76e73cde42f93a2bc8727d76dd6f488a0d7c9f41
