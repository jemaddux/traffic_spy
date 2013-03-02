module TrafficSpy
  class Payload
    def self.add_to_database(params)
       dataset = DB.from(:payload)
       dataset.insert(:url => params[:url],
                      :requestedAt => params[:requestedAt],
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

    def self.already_exist?(params)
      DB.from(:payload).where(:url => params[:url], 
                              :requestedAt => params[:requestedAt]).count > 0
    end

  end
end
