source 'https://rubygems.org'

ruby file: ".ruby-version"

gem 'rails', '~> 8.0'
gem 'sprockets'
gem 'sprockets-rails'

gem 'puma'
# Use postgresql as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby
# template
gem 'foundation-rails', '~>5.5'
gem 'nokogiri', '>=1.16'
gem 'slim-rails'
# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 2', group: :doc

gem 'ostruct'

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'rails-controller-testing'
gem 'spring', group: :development

# Devise for user authentication
gem 'devise'
gem "omniauth"
gem 'omniauth-google-oauth2'
gem "omniauth-rails_csrf_protection"
# and CanCan for authorization
gem 'cancancan'
gem 'rack-pratchett'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'byebug'
end

group :test, :development do
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'factory_bot_rails'
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-rubocop'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'rubocop', require: false
  gem 'rubocop-rspec', require: false
end

# Code climate CI integration
group :test do
  gem 'database_cleaner'
  gem "simplecov", require: false
end

group :production do
  gem 'redis'
end
# gem for heroku deployment
gem 'rails_12factor', group: :production

gem "webpacker", "~> 5.4"
gem "tzinfo-data"
