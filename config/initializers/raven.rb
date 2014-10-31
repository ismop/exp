if Settings['raven_dsn']
  require 'raven'

  Raven.configure do |config|
    config.dsn = Settings.raven_dsn
  end
end