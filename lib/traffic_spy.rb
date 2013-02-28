require "traffic_spy/version"
require 'sequel'
require 'traffic_spy/application'
require 'traffic_spy/identifiers'


module TrafficSpy

  DB = Sequel.sqlite

  DB.create_table :identifiers do
    primary_key :id
    String :identifier
    String :rootUrl
    DateTime :created_at
    DateTime :updated_at
  end

  # Your code goes here...
end



