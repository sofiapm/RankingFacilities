# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.precompile += %w( bootstrap-datepicker.js, bootstrap.js, bootstrap.min.js, bootstrap-theme.min.css, bootstrap.min.css, bootstrap.css.map.css, bootstrap.css.map, bootstrap-theme.css.map.css, bootstrap-theme.css.map )