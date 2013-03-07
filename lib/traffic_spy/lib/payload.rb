module TrafficSpy
  class Payload

    def self.database
      @database ||= DatabaseConnection.get_connection[:payload]
    end

    def self.destroy

    end

    def self.add_to_database(params)
       database.insert(:url => params[:url],
                      :requestedAt => params[:requestedAt],
                      :relative_path => convert_url_to_relative_path(params[:identifier],params[:url],params[:referredBy]),
                      :hour => params[:requestedAt][11..12],
                      :identifier_key => params[:identifier],
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

    def self.how_many_event_names(event_name)
      database.where(:eventName => event_name[:eventName]).count.to_i
    end

    def self.urls_times(url)
      temp = database.where(:url => url[:url]).select(:respondedIn)
      times = []
      temp.each do |tem|
        times << tem[:respondedIn].to_i
      end
      times.sort
    end

    def self.url_time_long(url)
      urls_times(url).last
    end

    def self.url_time_short(url)
      urls_times(url).first
    end

    def self.url_time_avg(url)
      sum = 0
      urls_times(url).each do |time|
        sum += time.to_i
      end
      sum / urls_times(url).count
    end

    def self.how_many_browser_visits(brw)
      database.where(:userAgent => brw[:userAgent]).count
    end

    def self.how_many_urls(url)
      database.where(:url => url[:url]).count
    end

    def self.get_events(identifier_key,eventName)
      database.where(:eventName => eventName, :identifier_key => identifier_key)
    end

    def self.convert_url_to_relative_path(identifier_key,url,referredBy)
      url.gsub(referredBy,"").gsub("http://www.","").gsub("http://","").gsub(".com","").gsub(".net","").gsub(".it","").gsub(identifier_key,"")
    end

    def self.already_exist?(params)
      database.where(:url => params[:url], 
                              :requestedAt => params[:requestedAt]).count > 0
    end

    def self.popular_urls_sorted(identifier)
      database.where(:identifier_key => identifier)
    end

    def self.browsers(identifier)
      database.where(:identifier_key => identifier).select(:userAgent)##################fix this
    end

    def self.oses(identifier)
      database.where(:identifier_key => identifier).select(:userAgent)##################
    end
      
    def self.screen_resolution(identifier)
      database.where(:identifier_key => identifier).select(:resolutionHeight, :resolutionWidth)
    end

    def self.response_times(identifier)
      database.where(:identifier_key => identifier).select(:respondedIn)
    end
      
    def self.events(identifier)
      database.where(:identifier_key => identifier).select(:eventName)
    end
      
    def self.url_exist(identifier,path)
      if Identifier.not_exist?(identifier)
        return false
      else
        root_path = Identifier.find_root_path(identifier).to_a[0][:rootUrl]
        database.where(:url => "#{root_path}/#{path}").to_a.count > 0
      end
    end

    def self.urls(identifier,path)
      root_path = Identifier.find_root_path(identifier).to_a[0][:rootUrl]
      database.where(:url => "#{root_path}/#{path}")
    end

    def self.event_exist?(identifier)
      database.where(:identifier_key => identifier).count > 0 
    end

    def self.how_many_events?(identifier,eventName)
     database.where(:identifier_key => identifier, :eventName => eventName).count
    end

    def self.specific_event_exist?(identifier, eventName)
      how_many_events?(identifier, eventName) > 0
    end

    def self.sorted_grouped_events(identifier)
      temp_data = database.where(:identifier_key => identifier)
      events = []
      temp_hash = Hash.new
      temp_data.each do |data|
        temp_hash = {}
        temp_hash[:eventName] = data[:eventName]
        temp_hash[:count] = how_many_events?(identifier, data[:eventName])
        events << temp_hash
      end
      events
    end

    def self.specific_events(identifier, eventName)
      dataset = database.where(:eventName => eventName, :identifier_key => identifier)
      temp_data = dataset#.group_by(:hour)
      hours = []
      temp_hash = Hash.new
      temp_data.each do |requestedAt|
        temp_hash = {}
        temp_hash[:hour] = requestedAt[:hour]
        temp_hash[:count] = how_many_hours?(identifier, eventName, requestedAt[:hour])
        hours << temp_hash
      end
      hours
    end

    def self.how_many_hours?(identifier, eventName, hour)
      database.where(:identifier_key => identifier, :eventName => eventName, :hour => hour).count
    end
  end
end












