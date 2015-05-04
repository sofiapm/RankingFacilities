require File.expand_path('../boot', __FILE__)

require 'csv'
require 'rails/all'

# require 'kpi.rb'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RankingFacilities
  class Application < Rails::Application

    config.assets.initialize_on_precompile = false
    ROLES_NAMES = { occupant: 'Occupant', owner: 'Owner', facility_manager: 'Facility Manager', service_operator: 'Service Operator' }
    #ROLES_SECTOR = { sector1: 'Sector 1', sector2: 'Sector 2', sector3: 'Sector 3', sector4: 'Sector 4', sector5: 'Sector 5', sector6: 'Sector 6'}
    
    ATTRIBUTES_NAMES = { nfa: 'Net Floor Area', pa: 'Primary Area', tlc: 'Total Level Area', fte: 'Full Time Equivalent',}
    ATTRIBUTES_UNITS = { nfa: 'm2', pa: 'm2'}

    METRIC_NAMES = { tlc: 'Total Labour Costs', tcc: 'Total Cleaning Cost', tsc: 'Total Space Cost', toc: 'Total Occupancy Cost',
     ae: 'Actual Expenses', ec: 'Energy Consumption', wc: 'Water Consumption' }
    METRIC_UNITS = { tlc: '€', tcc: '€', tsc: '€', toc: '€', ae: '€', fte: 'u', ec: 'kWh', wc: 'm3', wp: 'ton'}
    
    KPI_NAMES = { cc_nfa: 'Cleaning Cost per Square Meter', sc_nfa: 'Space Cost per Square Meter', oc_nfa: 'Occupancy Cost per Square Meter', 
        iwc: 'Internal Work Cost', cu: 'Capacity by Utilization', se: 'Space Experience', ec_nfa: 'Energy Consumption by NFA', wc_fte: 'Water Consumption by FTE', wp_fte: 'Waste Production by FTE'}
    KPI_UNITS = { cc_nfa: '€/m2', sc_nfa: '€/m2', oc_nfa: '€/m2', 
        iwc: '%', cu: 'm2', se: '%', ec_nfa: 'kWh/m2', wc_fte: 'm3/FTE', wp_fte: 'ton/FTE'}

    CITIES = {p0: '', p138: 'A Coruña', p124: 'Aachen', p84: 'Alicante', p25: 'Amsterdam',  p61: 'Antwerp', p30:    'Athens', p121: 'Augsburg', p11:    'Barcelona', p89:   'Bari', p113:   'Belfast', p2:  'Berlin', p105: 'Białystok', p86:   'Bielefeld', p79:   'Bilbao', p18:  'Birmingham', p70:  'Bochum', p72:  'Bologna', p95: 'Bonn', p141:   'Bordeaux', p104:   'Bradford', p65:    'Bratislava', p135: 'Braunschweig', p112:   'Braşov', p45:  'Bremen', p115: 'Brighton & Hove', p66: 'Bristol', p68: 'Brno', p20:    'Brussels', p10:    'Bucharest', p7:    'Budapest', p73:    'Bydgoszcz', p91:   'Cardiff', p94: 'Catania', p139:    'Chemnitz', p98:    'Cluj-Napoca', p19: 'Cologne', p100:    'Constanţa', p17:   'Copenhagen', p99:  'Coventry', p102:   'Craiova', p133:    'Częstochowa', p92: 'Córdoba', p58: 'Den Haag', p149:   'Derby', p41:   'Dortmund', p50:    'Dresden', p49: 'Dublin', p56:  'Duisburg', p40:    'Düsseldorf', p62:  'Edinburgh', p128:  'Espoo', p42:   'Essen', p77:   'Florence', p33:    'Frankfurt', p106:  'Galaţi', p60:  'Gdańsk', p126: 'Gdynia', p120: 'Gelsenkirchen', p37:   'Genoa', p148:  'Ghent', p119:  'Gijón', p39:   'Glasgow', p44: 'Gothenburg', p140: 'Granada', p131:    'Graz', p143:   'Halle (Saale)', p6:    'Hamburg', p52: 'Hanover', p36: 'Helsinki', p90:    'Iaşi', p108:   'Karlsruhe', p87:   'Katowice', p74:    'Kaunas', p144: 'Kiel', p101:   'Kingston upon Hull', p146: 'Košice', p27:  'Kraków', p142: 'Krefeld', p134:    "L'Hospitalet", p63:    'Leeds', p85:   'Leicester', p51:   'Leipzig', p53: 'Lisbon', p59:  'Liverpool', p111:  'Ljubljana', p1:    'London', p78:  'Lublin', p57:  'Lyon', p3: 'Madrid', p110: 'Malmö', p55:   'Manchester', p97:  'Mannheim', p23:    'Marseille', p129:  'Messina', p14: 'Milan', p125:  'Montpellier', p13: 'Munich', p71:  'Murcia', p48:  'Málaga', p122: 'Mönchengladbach', p118:    'Münster', p109:    'Nantes', p21:  'Naples', p81:  'Nice', p132:   'Nottingham', p54:  'Nuremberg', p93:   'Ostrava', p32: 'Palermo', p76: 'Palma de Mallorca', p5:    'Paris', p82:   'Plovdiv', p136:    'Plymouth', p137:   'Porto', p43:   'Poznań', p15:  'Prague', p28:  'Riga', p4: 'Rome', p47:    'Rotterdam', p31:   'Seville', p64: 'Sheffield', p16:   'Sofia', p150:  'Sosnowiec', p145:  'Southampton', p12: 'Stockholm', p123:  'Stoke-on-Trent', p116: 'Strasbourg', p38:  'Stuttgart', p67:   'Szczecin', p69:    'Tallinn', p80: 'Thessaloniki', p96:    'Timișoara', p64:   'Toulouse', p22:    'Turin', p107:  'Utrecht', p24: 'Valencia', p88:    'Valladolid', p83:  'Varna', p117:  'Venice', p127: 'Verona', p8:   'Vienna', p103: 'Vigo', p46:    'Vilnius', p9:  'Warsaw', p114: 'Wiesbaden', p130:  'Wolverhampton', p34:   'Wrocław', p75: 'Wuppertal', p26:   'Zagreb', p35:  'Zaragoza', p29:    'Łódź'}

    COUNTRY = {p0: '', p1: 'Albania', p2: 'Andorra', p3: 'Armenia', p4: 'Austria', p5: 'Azerbaijan', p6: 'Belarus', p7: 'Belgium', p8: 'Bosnia & Herzegovina', p9: 'Bulgaria', p10: 'Croatia', p11: 'Cyprus', p12: 'Czech Republic', p13: 'Denmark', p14: 'Estonia', p15: 'Finland', p16: 'France', p17: 'Georgia', p18: 'Germany', p19: 'Greece', p20: 'Hungary', p21: 'Iceland', p22: 'Ireland', p23: 'Italy', p24: 'Kosovo', p25: 'Latvia', p26: 'Liechtenstein', p27: 'Lithuania', p28: 'Luxembourg', p29: 'Macedonia', p30: 'Malta', p31: 'Moldova', p32: 'Monaco', p33: 'Montenegro', p34: 'The Netherlands', p35: 'Norway', p36: 'Poland', p37: 'Portugal', p38: 'Romania', p39: 'Russia', p40: 'San Marino', p41: 'Serbia', p42: 'Slovakia', p43: 'Slovenia', p44: 'Spain', p45: 'Sweden', p46: 'Switzerland', p47: 'Turkey', p48: 'Ukraine', p49: 'United Kingdom', p50: 'Vatican City'}
    
    SECTORS = {p0: '', health: 'Healthcare', pharmaceutical_chemical: 'Pharmaceutical and Chemical', education: 'Education', environmental: 'Environmental', hospitality_tourism: 'Hospitality and Tourism',
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
    config.autoload_paths += Dir["#{config.root}/lib/**/"]
    config.assets.initialize_on_precompile = false
    
    
  end
end
