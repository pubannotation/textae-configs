source 'https://rubygems.org'
ruby '3.4.2'

gem 'rails', '~> 8.0.1'
gem 'rake'

gem 'puma'
gem 'sass-rails'
gem 'uglifier'
gem 'coffee-rails'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

gem 'sprockets-rails'

gem 'sqlite3'

gem 'friendly_id'
gem 'wice_grid', github: 'yush-nh/wice_grid'

# The csv gem is added because wice_grid currently relies on the standard library version of csv,
# which will no longer be included as a default gem starting from Ruby 3.4.0.
# Remove the csv gem from the Gemfile once wice_grid updates to support Ruby 3.4.0 or later.
gem 'csv'
gem 'font-awesome-rails'

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
end

group :development do
	gem 'dotenv-rails'

	# Access an IRB console on exception pages or by using <%= console %> in views
	gem 'web-console'

	# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
	gem 'spring'
end

gem 'devise'
gem 'omniauth'
gem 'omniauth-rails_csrf_protection'
gem 'omniauth-google-oauth2'
gem 'omniauth-github'

gem 'rack-cors'
