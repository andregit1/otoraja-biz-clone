source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.3'
# Use mysql as the database for Active Record
gem 'mysql2', '>= 0.4.4', '< 0.6.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# Add gem
gem 'bootstrap', '~> 4.1.1'
gem 'jquery-rails'
gem 'icheck-rails'
gem 'font-awesome-sass'

gem 'kaminari'

gem 'devise'
gem 'devise-i18n'
gem 'devise-i18n-views'

gem 'pundit'

gem 'aws-sdk'

gem 'activerecord-session_store'

gem 'config'
gem 'yaml_vault'

gem 'phonelib'
gem 'ransack'
gem 'cocoon'
gem 'serviceworker-rails'

gem 'switch_user'
gem 'ancestry'
gem 'jquery-ui-rails'

gem 'prawn'
gem 'prawn-table'
gem 'prawn-templates'
gem 'pdfjs_viewer-rails'

gem 'data-confirm-modal'

gem 'elasticsearch', '< 6.7.1'
gem 'elasticsearch-model', '< 6.7.1'
gem 'elasticsearch-rails', '< 6.7.1'

gem 'devise-two-factor'
gem 'rqrcode'
gem 'dotenv-rails'
gem 'shortener'
gem 'activerecord-import'

gem 'devise_token_auth'
gem 'roo'

gem 'enum_help'
gem 'recaptcha'

gem 'rails-i18n'
gem 'caxlsx'
gem 'caxlsx_rails'

gem 'discard'

group :production, :staging, :design do
  gem 'asset_sync'
  gem 'fog-aws'
  gem 'lograge'
end
# /Add gem

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
  gem 'simplecov'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem "activerecord-import"