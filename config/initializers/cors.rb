Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins do |source, env|
      source unless source == 'null'
    end
    resource '/configs/*', methods: :any, headers: :any
  end
end
