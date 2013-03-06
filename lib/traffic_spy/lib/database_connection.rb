module TrafficSpy
  class DatabaseConnection
    def self.get_connection
      @connection ||= connect
    end


    def self.database
      @database
    end

    def self.delete_all
      @payload = DatabaseConnection.get_connection[:payload]
      @payload.delete
      @campaigns = DatabaseConnection.get_connection[:campaigns]
      @event_names = DatabaseConnection.get_connection[:event_names]
      @identifiers = DatabaseConnection.get_connection[:identifiers]
    end

    def self.connect
      @database = Sequel.connect 'postgres://localhost/traffic_spy'
      Sequel.extension :migration
      #Sequel::Migrator.check_current(database, 'db/migrations')
      @database
    end
  end
end

