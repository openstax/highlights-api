secrets = Rails.application.secrets.accounts[:sso]

OpenStax::Auth.configure do |config|
  config.strategy_1_secret_key = secrets[:secret_key]
  config.strategy_1_secret_salt = secrets[:secret_salt]
  config.strategy_1_cookie_name = secrets[:cookie_name]
end
