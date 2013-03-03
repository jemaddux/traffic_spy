require "traffic_spy/identifiers"

module TrafficSpy
  class Payload
    def self.add_to_database(params)
       #identifier_key = Identifier.find_id()
       dataset = DB.from(:payload)
       dataset.insert(:url => params[:url],
                      :requestedAt => params[:requestedAt],
                      :relative_path => convert_url_to_relative_path(params[:splat][0],params[:url]),
                      :identifier_key => params[:splat][0],
                      :respondedIn => params[:respondedIn],
                      :referredBy => params[:referredBy],
                      :requestType => params[:requestType],
                      :parameters => params[:parameters],
                      :eventName => params[:eventName],
                      :userAgent => params[:userAgent],
                      :resolutionWidth => params[:resolutionWidth],
                      :resolutionHeight => params[:resolutionHeight],
                      :ip => params[:ip],
                      :created_at => Time.now,
                      :updated_at => Time.now)
    end

    def self.convert_url_to_relative_path(identifier_key,url)
      url.gsub("http://www.","").gsub("http://","").gsub(".com","").gsub(".net","").gsub(".it","").gsub(identifier_key,"")
    end

    def self.already_exist?(params)
      DB.from(:payload).where(:url => params[:url], 
                              :requestedAt => params[:requestedAt]).count > 0
    end

    def self.popular_urls_sorted(identifier)
      DB.from(:payload).where(:identifier_key => identifier).select(:url)
    end

    def self.browsers(identifier)
      DB.from(:payload).where(:identifier_key => identifier).select(:userAgent)##################fix this
    end

    def self.oses(identifier)
      DB.from(:payload).where(:identifier_key => identifier).select(:userAgent)##################
    end
      
    def self.screen_resolution(identifier)
      DB.from(:payload).where(:identifier_key => identifier).select(:resolutionHeight, :resolutionWidth)
    end

    def self.response_times(identifier)
      DB.from(:payload).where(:identifier_key => identifier).select(:respondedIn)
    end
      
    def self.events(identifier)
      DB.from(:payload).where(:identifier_key => identifier).select(:eventName)
    end
      
    def self.url_exist?(params)
      DB.from(:payload).where(:identifier_key => params[0], :relative_path => "/#{params[1]}").count > 0
    end

    def self.sorted_url_response_times(params)
      DB.from(:payload).where(:identifier_key => params[0], :relative_path => "/#{params[1]}").select(:respondedIn)
    end
  end
end












