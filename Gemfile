source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '6.1.7.10'

# Remove this entry after Rails is updated further
gem 'concurrent-ruby', '1.3.4'

# Use postgresql as the database for Active Record
gem 'pg'
# Use Puma as the app server
gem 'puma'

# Versioned API tools
gem 'versionist'

# More concise, one-liner logs (better for production)
gem 'lograge'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder'
# Use Redis adapter to run Action Cable in production
# gem 'redis'
# Use ActiveModel has_secure_password
# gem 'bcrypt'

# Use ActiveStorage variant
# gem 'mini_magick'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

# Gives 200 OK from /ping
gem 'openstax_healthcheck'

# For installing secrets on deploy
gem "aws-sdk-ssm"

gem 'dotenv-rails'

gem 'will_paginate'

gem "openstax_swagger", github: 'openstax/swagger-rails'

# Allow requests with a 'highlights' prefix to support use via CloudFront
gem "openstax_path_prefixer", github: 'openstax/path_prefixer'

gem "openstax_auth"

gem 'openstax_content'
gem 'addressable'
gem 'nokogiri'

# Exception reporting
gem 'sentry-raven'

# Profiling
gem 'scout_apm'

# CORS
gem 'rack-cors'

gem 'with_advisory_lock'

gem 'sucker_punch'

group :test do
  # Code Climate integration
  # gem "codeclimate-test-reporter", require: false

  gem 'codecov', require: false
  gem 'simplecov', require: false
end

group :development, :test do
  gem 'factory_bot_rails'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

  gem 'pry-rails'

  gem 'rspec-json_expectations'
  gem 'rspec-rails'

  gem 'rubocop'
end

group :development do
  gem 'listen'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '< 4.3'
  gem 'spring-watcher-listen'
  gem 'spring-commands-rspec'

  gem 'rack-mini-profiler'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
