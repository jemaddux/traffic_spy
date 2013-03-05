Sequel.migration do
  change do
    create_table :identifiers do
      primary_key :id
      String :identifier
      String :rootUrl
      DateTime :created_at
      DateTime :updated_at
    end

    create_table :campaigns do
      primary_key :id
      String :identifier
      String :campaignName
      DateTime :created_at
      DateTime :updated_at
    end

    create_table :event_names do
      primary_key :id
      String :campaignName
      String :identifier
      String :eventName
      DateTime :created_at
      DateTime :updated_at
    end

    create_table :payload do
      primary_key :id
      String :identifier_key
      String :url
      String :relative_path
      String :hour
      String :requestedAt
      Integer :respondedIn
      String :referredBy
      String :requestType
      String :parameters
      String :eventName
      String :userAgent
      String :resolutionWidth
      String :resolutionHeight
      String :ip
      DateTime :created_at
      DateTime :updated_at
    end
  end
end
