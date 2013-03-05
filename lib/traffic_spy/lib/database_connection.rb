module TrafficSpy
  class DatabaseConnection
    def self.get_connection
      @connection ||= connect
    end

    private

    def self.connect
      database = Sequel.connect 'postgres://localhost/traffic_spy'
      Sequel.extension :migration
      Sequel::Migrator.check_current(database, 'db/migrations')
      database
    end
  end
end
