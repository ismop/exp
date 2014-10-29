web: bundle exec puma -C ./config/puma.rb
worker: bundle exec sidekiq -q monitoring -q billing -q cloud
clock: bundle exec clockwork app/clock.rb