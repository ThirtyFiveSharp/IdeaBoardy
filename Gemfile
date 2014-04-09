source 'https://rubygems.org'

gem 'rails', '~> 3.2.12'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

group :production do
  gem 'pg', '~> 0.14.1'
  gem 'eventmachine', '~> 1.0.0'
  gem 'thin', '~> 1.5.0'
end

group :development, :test do
  gem 'sqlite3', '~> 1.3.6'
  gem 'jasmine', '~> 1.3.1'
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'capybara-angular'
  gem 'cucumber-rails', :require => false
  gem 'database_cleaner'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.6'
  gem 'coffee-rails', '~> 3.2.2'
  gem 'jquery-rails', '~> 2.2.1'
  gem 'jquery-ui-rails', '~> 3.0.1'
  gem 'underscore-rails', '~> 1.4.3'
  gem 'angularjs-rails', '~> 1.0.4'
  gem 'jquery_mobile_rails'

  gem 'uglifier', '~> 1.3.0'
end

gem 'devise', '~> 2.2.3'
gem 'simplecov', :require => false, :group => :test

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
