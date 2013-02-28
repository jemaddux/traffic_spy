module TrafficSpy
  class Identifier
    def self.add_to_database(params)
       dataset = DB.from(:identifiers)
       dataset.insert(:identifier => params[:identifier], :rootUrl => params[:rootUrl])
    end

    def self.already_exist?(input)
      DB.from(:identifiers).where(:identifier => input).to_a.count > 0
    end

  end
end


