json.extract! config, :id, :name, :description, :body, :is_public, :created_at, :updated_at
json.url config_url(config, format: :json)
