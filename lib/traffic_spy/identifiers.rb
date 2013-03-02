module TrafficSpy
  class Identifier
    def self.add_to_database(params)
       dataset = DB.from(:identifiers)
       dataset.insert(:identifier => params[:identifier], :rootUrl => params[:rootUrl], :created_at => Time.now, :updated_at => Time.now)
    end

    def self.already_exist?(input)
      DB.from(:identifiers).where(:identifier => input).count > 0
    end

    def self.not_exist?(input)
      DB.from(:identifiers).where(:identifier => input).count == 0
    end

    def self.testing
      "Hobbits"
    end

  end
end


