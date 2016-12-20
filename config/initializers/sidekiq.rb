sidekiq_connection = {
  url: Settings.sidekiq.url,
  namespace: Settings.sidekiq.namespace
}

Sidekiq.configure_server do |config|
  config.redis = sidekiq_connection
end

Sidekiq.configure_client do |config|
  config.redis = sidekiq_connection
end
