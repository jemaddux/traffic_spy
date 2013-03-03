require "traffic_spy/version"
require 'sequel'
require 'traffic_spy/fake_data'
require 'traffic_spy/identifiers'
require 'sinatra/base'
     

module TrafficSpy

  DB = Sequel.sqlite

  DB.create_table :identifiers do
    primary_key :id
    String :identifier
    String :rootUrl
    DateTime :created_at
    DateTime :updated_at
  end

  DB.create_table :payload do
    primary_key :id
    String :identifier_key
    String :url
    String :relative_path
    String :requestedAt
    Integer :respondedIn
    String :referredBy
    String :requestType
    String :parameters
    String :eventName
    String :userAgent
    String :resolutionWidth
    String :resolutionHeight
    String :ip
    DateTime :created_at
    DateTime :updated_at
  end



  # Your code goes here...

  # :url => "http://www.amazon.com/blog",
  #         :requestedAt => "2013-02-16 21:38:28 -0700",
  #         :respondedIn => 37,
  #         :referredBy => "http://www.amazon.com",
  #         :requestType => "GET",
  #         :parameters => [],
  #         :eventName => "socialLogin",
  #         :userAgent => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
  #         :resolutionWidth => "1920",
  #         :resolutionHeight => "1280",
  #         :ip =>
end



