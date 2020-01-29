source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.3'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.12'

# Versioned API tools
gem 'versionist'

# More concise, one-liner logs (better for production)
gem 'lograge'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
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

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

# Gives 200 OK from /ping
gem 'openstax_healthcheck'

# For installing secrets on deploy
gem "aws-sdk-ssm"

gem 'dotenv-rails'

gem 'will_paginate', '~> 3.1.7'

gem "openstax_swagger", github: 'openstax/swagger-rails', ref: '9bff4962b31e142debbc62390f1fd3adab3af055'

# Allow requests with a 'highlights' prefix to support use via CloudFront
gem "openstax_path_prefixer", github: 'openstax/path_prefixer', ref: '0ed5cdba6be65dbf1d07fd7580e2311a2f42cdfd'

#gem "openstax_auth", github: 'openstax/auth-rails', ref: '1e4268f422bfa2562de3a8e57b6471cbb09f86ea'
gem "openstax_auth", github: 'openstax/auth-rails', branch: 'sb/763-strategy2-asym-decode'

# Exception reporting
gem 'sentry-raven'

# Profiling
gem 'scout_apm', '~> 3.0.x'

# CORS
gem 'rack-cors'

gem 'with_advisory_lock'

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
  gem 'rspec-rails', '~> 3.8'

  gem 'rubocop'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end


# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
