require "traffic_spy/event_names"

module TrafficSpy
  class Campaigns
    def self.add_to_database(params)
       dataset = DB.from(:campaigns)
       dataset.insert(:campaignName => params[:campaignName],
                      :identifier => params[:identifier],
                      :created_at => Time.now,
                      :updated_at => Time.now)

       EventNames.add_to_database(params)
    end

    def self.exist?(params)
      DB.from(:campaigns).where(:campaignName => params[:campaignName]).count > 0
    end

    def self.does_exist?(identifier)
      DB.from(:campaigns).where(:identifier => identifier).count > 0
    end

  end
end







