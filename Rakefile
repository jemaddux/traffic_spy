require "bundler/gem_tasks"

require 'sequel'
require 'traffic_spy/lib/database_connection'

namespace :db do
  desc "Run migrations"
  task :migrate => [:setup] do
    Sequel::Migrator.run(@database, "db/migrations")
  end

  desc "Reset database"
  task :reset => [:setup] do
    Sequel::Migrator.run(@database, "db/migrations", :target => 0)
    Sequel::Migrator.run(@database, "db/migrations")
  end

  task :setup do
    Sequel.extension :migration
    database_path = 'traffic_spy'
    puts "Using database: #{database_path}"
    @database = Sequel.postgres database_path
  end

  desc "Setup the test database"
  task :test_prepare do
    TrafficSpy::DatabaseConnection.destroy_database(:test)
    Sequel.extension :migration
    db = TrafficSpy::DatabaseConnection.database_for(:test)
    Sequel::Migrator.run(db, "db/migrations")
  end
end



# THIS SPACE RESERVED FOR EVALUATIONS
#
#
#
#
# THIS SPACE RESERVED FOR EVALUATIONS
