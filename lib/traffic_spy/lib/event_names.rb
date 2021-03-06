module TrafficSpy
  class EventNames
    def self.add_to_database(params)
      params[:eventNames].each do |eventName|
        database.insert(:campaignName => params[:campaignName],
                        :identifier => params[:identifier],
                        :eventName => eventName,
                        :created_at => Time.now,
                        :updated_at => Time.now)
      end
    end

    def self.database
      @database ||= DatabaseConnection.get_connection[:event_names]
    end

    def self.list(params)
      database.where( :campaignName => params[:campaignName])
    end


  end
end
