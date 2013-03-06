module TrafficSpy
  class Identifier
    def self.add_to_database(params)
       database.insert(:identifier => params[:identifier], :rootUrl => params[:rootUrl], :created_at => Time.now, :updated_at => Time.now)
    end

    def self.find_root_path(identifier)
      database.where(:identifier => identifier)
    end

    def self.already_exist?(input)
      database.where(:identifier => input).count > 0
    end

    def self.not_exist?(input)
      database.where(:identifier => input).count == 0
    end

    def self.find_id(input)
      database.where(:identifier => input).select(:id)
    end

    def self.database
      @database ||= DatabaseConnection.get_connection[:identifiers]
    end
  end
end


