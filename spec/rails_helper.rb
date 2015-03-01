# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require 'spec_helper'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
# require 'OmniAuth/GoogleOauth2'
# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|

  config.include Devise::TestHelpers, type: :controller
  config.infer_spec_type_from_file_location!
  # config.include(OmniauthMacros)
  # OmniAuth.config.test_mode = true
  # OmniAuth.config.add_mock(
  #     :create_new_user,
  #     {
  #         :info => {
  #             :email => 'failing@non-existant.com',
  #             :name=>'Test User'
  #         }
  #     })
  # OmniAuth.config.add_mock(
  #     :find_existing,
  #     {
  #         :info => {
  #             :email => 'user1@example.com',
  #             :name=>'Test User'
  #         }
  #     })

end
