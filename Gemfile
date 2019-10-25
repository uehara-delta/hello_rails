# coding: utf-8
source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.0'
# Use mysql as the database for Active Record (only develpment and test environment)
gem 'mysql2', '>= 0.4.4', '< 0.6.0', group: [:development, :test]
# Use posgresql as the databasy for Active Record (for production environment)
gem 'pg', group: :production

# Use Puma as the app server
gem 'puma', '~> 4.2.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 6.0.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '~> 4.2.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 5.0.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5.2.1'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.9.1'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '~> 1.4.5', require: false

group :development, :test do
  gem 'rspec-rails', '~> 4.0.0.beta2'
  gem 'factory_bot_rails', '~> 5.1'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'pry-doc'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '~> 4.0'
  gem 'listen', '~> 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '~> 2.1'
  gem 'spring-watcher-listen', '~> 2.0'
  gem 'spring-commands-rspec', '~> 1.0'
  gem 'hirb', '~> 0.7.3'
  gem 'hirb-unicode', '~> 0.0.5'
  gem "letter_opener", '~> 1.7.0'
end

group :test do
  gem 'capybara', '~> 3.29'
  gem 'webdrivers', '~> 4.1.3'
  gem 'selenium-webdriver'
  gem 'launchy', '~> 2.4.3'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Haml
gem 'haml-rails', '~> 2.0.1'

# 日本語化
gem 'rails-i18n', '~> 6.0.0'

# font awesome
gem 'font-awesome-sass', '~> 5.11'

# Bootstrap
gem 'bootstrap', '~> 4.3.1'
gem 'jquery-rails', '~> 4.3.5'
gem 'popper_js', '~> 1.14.5'
gem 'tether-rails', '~> 1.4.0'

# simple_form
gem 'simple_form', '~> 5.0.1'

# Devise
gem 'devise'

# Google login
gem 'omniauth'
gem 'omniauth-google-oauth2'
gem 'omniauth-rails_csrf_protection', '~> 0.1'

# Enumerize
gem 'enumerize'

# CarrierWave
gem 'carrierwave', '~> 2.0'

# Ransack
gem 'ransack', github: 'activerecord-hackery/ransack'
