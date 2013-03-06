module TrafficSpy
  class DatabaseConnection
    def self.get_connection
      database
    end

    def self.database
      @database || database_for(:development)
    end

    def self.database_for(env_flag)
      if env_flag == :test
        @database = Sequel.sqlite 'db/traffic_spy_test.sqlite3'
      else
        @database = Sequel.connect 'postgres://localhost/traffic_spy'
      end
    end

    def self.destroy_database(env_flag)
      if env_flag == :test
        `rm db/traffic_spy_test.sqlite3`
      else
        raise "This method will not destroy the dev/production databases"
      end
    end

    def self.delete_all
      @payload = DatabaseConnection.get_connection[:payload]
      @payload.delete
      @campaigns = DatabaseConnection.get_connection[:campaigns]
      @campaigns.delete
      @event_names = DatabaseConnection.get_connection[:event_names]
      @event_names.delete
      @identifiers = DatabaseConnection.get_connection[:identifiers]
      @identifiers.delete
    end
  end
end

