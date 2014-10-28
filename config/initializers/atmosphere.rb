Atmosphere.setup do |config|
  if Settings['sidekiq']
    config.sidekiq.url = Settings.sidekiq.url
    config.sidekiq.namespace = Settings.sidekiq.namespace
  end
end