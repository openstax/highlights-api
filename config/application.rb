require_relative "boot"

require "rails"

# Pick the frameworks you want:
require "active_model/railtie"
# require "active_job/railtie"
require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
# require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
# require "action_view/railtie"
# require "action_cable/engine"
# require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module HighlightsApi
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    config.eager_load_paths << Rails.root.join('lib')

    # disable the ip spoofing check to allow use of the x-forward-for
    # see https://github.com/rails/rails/blob/6-0-stable/actionpack/lib/action_dispatch/middleware/remote_ip.rb#L118-L149
    config.action_dispatch.ip_spoofing_check = false

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
Dotenv.load('/etc/.env', '/etc/default/openstax')
