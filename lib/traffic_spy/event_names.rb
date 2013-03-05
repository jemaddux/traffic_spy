require "traffic_spy"

module TrafficSpy
  class EventNames
    def self.add_to_database(params)
      params[:eventNames].each do |eventName|
        dataset = DB.from(:event_names)
        dataset.insert(:campaignName => params[:campaignName],
                        :identifier => params[:splat],
                        :eventName => eventName,
                        :created_at => Time.now,
                        :updated_at => Time.now)
      end
    end
  end
end
