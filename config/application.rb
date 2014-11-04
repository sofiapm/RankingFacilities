require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RankingFacilities
  class Application < Rails::Application

    config.assets.initialize_on_precompile = false
    ROLES_NAMES = { occupant: 'Occupant', owner: 'Owner', facility_manager: 'Facility Manager', service_operator: 'Service Operator' }
    ROLES_SECTOR = { sector1: 'Sector 1', sector2: 'Sector 2', sector3: 'Sector 3', sector4: 'Sector 4', sector5: 'Sector 5', sector6: 'Sector 6'}
  
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
  end
end
