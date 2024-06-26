require File.expand_path('../boot', __FILE__)

require "rails"

# Include each railties manually, excluding `active_storage/engine`
%w(
  active_record/railtie
  action_controller/railtie
  action_view/railtie
  action_mailer/railtie
  active_job/railtie
  action_cable/engine
  rails/test_unit/railtie
  sprockets/railtie
).each do |railtie|
  begin
    require railtie
  rescue LoadError
  end
end
require_relative '../lib/global_constants'
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Eurovision
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # keep the name alive
    config.active_support.cache_format_version = 7.1
    config.middleware.use Rack::Pratchett
    config.action_dispatch.return_only_media_type_on_content_type = false
    Rails.autoloaders.main.ignore(Rails.root.join('/app/app/webpacker/images/16'))
    Rails.autoloaders.main.ignore(Rails.root.join('/app/app/webpacker/images/32'))
    Rails.autoloaders.main.ignore(Rails.root.join('/app/app/webpacker/images/64'))
  end
end
