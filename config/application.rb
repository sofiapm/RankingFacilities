require File.expand_path('../boot', __FILE__)

require 'csv'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RankingFacilities
  class Application < Rails::Application

    config.assets.initialize_on_precompile = false
    ROLES_NAMES = { occupant: 'Occupant', owner: 'Owner', facility_manager: 'Facility Manager', service_operator: 'Service Operator' }
    #ROLES_SECTOR = { sector1: 'Sector 1', sector2: 'Sector 2', sector3: 'Sector 3', sector4: 'Sector 4', sector5: 'Sector 5', sector6: 'Sector 6'}
    
    ATTRIBUTES_NAMES = { nfa: 'Net Floor Area', pa: 'Primary Area'}
    ATTRIBUTES_UNITS = { nfa: 'm2', pa: 'm2'}

    METRIC_NAMES = { tlc: 'Total Labour Costs', ae: 'Actual Expenses', fte: 'Full Time Equivalent', ec: 'Energy Consumption', wc: 'Water Consumption', wp: 'Waste Production' }
    METRIC_UNITS = { tlc: '€', ae: '€', fte: 'u', ec: 'kWh', wc: 'm3', wp: 'ton'}
    
    KPI_NAMES = { iwc: 'Internal Work Cost', cu: 'Capacity by Utilization', se: 'Space Experience', ec_nfa: 'Energy Consumption by NFA', wc_fte: 'Water Consumption by FTE', wp_fte: 'Waste Production by FTE'}
    KPI_UNITS = { iwc: '%', cu: 'm2', se: '%', ec_nfa: 'kWh/m2', wc_fte: 'm3/FTE', wp_fte: 'ton/FTE'}

    SECTORS = {health: 'Healthcare', pharmaceutical_chemical: 'Pharmaceutical and Chemical', education: 'Education', environmental: 'Environmental', hospitality_tourism: 'Hospitality and Tourism',
                real_estate: 'Real Estate', construction: 'Construction', airline_industry: 'Airline Industry', banking: 'Banking',
                insurance: 'Insurance', financial_services: 'Financial Services', manufacturing: 'Manufacturing', telecommunication: 'Telecommunication',
                transportation: 'Transportation', media: 'Media', support_services: 'Support Services', textil_clothing: 'Textils and Clothing',
                hiring_leasing: 'Hiring and Leasing', food_retailing: 'Food Retailing', food_manufacturing: 'Food Manufacturing', other: 'Other'}
    
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
