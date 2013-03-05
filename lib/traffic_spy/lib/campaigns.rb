module TrafficSpy
  class Campaigns
    def self.add_to_database(params)
       database.insert(:campaignName => params[:campaignName],
                      :identifier => params[:identifier],
                      :created_at => Time.now,
                      :updated_at => Time.now)

       EventNames.add_to_database(params)
    end

    def self.database
      @database ||= DatabaseConnection.get_connection[:campaigns]
    end

    def self.list(identifier)
      database.where(:identifier => identifier)
    end    

    def self.exist?(params)
      database.where(:campaignName => params[:campaignName]).count > 0
    end

    

    def self.does_exist?(identifier)
      database.where(:identifier => identifier).count > 0
    end

    def self.campaignName_exist?(params)
      exist?(params) && does_exist?(params[:identifier])
    end

  end
end







