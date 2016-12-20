source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.0'
# Use postgresql as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 3.0.4'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.2.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'atmosphere',
    github: 'dice-cyfronet/atmosphere',
    branch: 'master'

# Cross-Origin Resource Scharing for external UIs
gem 'rack-cors', require: 'rack/cors'

gem 'settingslogic'

group :development do
  gem 'letter_opener'
  # gem 'rack-mini-profiler'

  # Better error page
  gem 'better_errors'
  gem 'binding_of_caller'

  gem 'rails_best_practices'

  gem 'foreman'
end

group :development, :test do
  gem 'pry-rails'

  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'guard-rspec', require: false
end

group :test do
  gem 'rspec-rails'
  gem 'shoulda-matchers'

  gem 'factory_girl'
  gem 'ffaker', '~>2.0.0'
  gem 'database_cleaner'
end

gem 'puma'
gem 'clockwork'
