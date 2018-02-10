source 'https://rubygems.org'
ruby '2.5.0'
gem 'rails', '>= 5.1'
gem 'sprockets-rails', '~>3.0'
# Use postgresql as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby
# template
gem 'foundation-rails', '~>5.5'
gem 'nokogiri', '>=1.7'
gem 'slim-rails'
# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 1', group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'rails-controller-testing'
gem 'spring', group: :development

# Devise for user authentication
gem 'devise', github: 'plataformatec/devise'
gem 'omniauth-google-oauth2'
# and CanCan for authorization
gem 'acts_as_list'
gem 'cancancan'
gem 'rack-pratchett'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :test, :development do
  gem 'factory_bot_rails'
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-rubocop'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'rubocop', '~>0.39', require: false
  gem 'rubocop-rspec', '~>1', require: false
end

# Code climate CI integration
group :test do
  gem 'codeclimate-test-reporter', require: nil
  gem 'database_cleaner'
end

group :production do
  gem 'redis'
end
# gem for heroku deployment
gem 'rails_12factor', group: :production
