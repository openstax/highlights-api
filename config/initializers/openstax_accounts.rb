secrets = Rails.application.secrets.accounts[:sso]

OpenStax::Accounts.configure do |config|
  config.sso_secret_key = secrets[:secret_key]
  config.sso_secret_salt = secrets[:secret_salt]
  config.sso_cookie_name = secrets[:cookie_name]
end
