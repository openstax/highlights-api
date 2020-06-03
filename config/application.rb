require_relative 'boot'

require "rails"

# This is the railtie middleware stack.
# !! Have removed some of these to improve API performance. !!
require "active_model/railtie"
# can comment out active_job/railtie after next 5.2.x release, see
# https://github.com/rails/rails/pull/35896#issuecomment-535569136
require "active_job/railtie"
require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
# require "action_mailer/railtie"
# require "action_view/railtie"

# require "action_cable/engine"
# require "sprockets/railtie"
# require "rails/test_unit/railtie"

require_relative "../lib/not_authorized"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module HighlightsApi
  class Application < Rails::Application


    config.middleware.use NotAuthorized::Middleware

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '/api/v0/swagger', headers: :any, methods: [:get, :options, :head]
      end
    end

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    config.eager_load_paths << Rails.root.join('lib')

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    # default any new models to uuid as id
    config.generators do |g|
      g.orm :active_record, primary_key_type: :uuid
    end

    def load_testing?
      Rails.application.secrets[:loadtesting_active] == 'true'
    end
  end
end

# Load system-wide env vars, will be set on EC2 instances, ignored otherwise
Dotenv.load('/etc/.env')
