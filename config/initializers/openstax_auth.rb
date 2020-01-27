secrets = Rails.application.secrets.accounts[:sso]

OpenStax::Auth.configure do |config|
  config.strategy_2_signature_public_key = secrets[:signature_public_key]
  config.strategy_2_encryption_private_key = secrets[:encryption_private_key]
  config.strategy_2_cookie_name = secrets[:cookie_name] || 'oxa'
  config.strategy_2_encryption_algorithm = secrets[:encryption_algorithm] || 'dir'
  config.strategy_2_encryption_method = secrets[:encryption_method] || 'A256GCM'
  config.strategy_2_signature_algorithm = secrets[:signature_algorithm] || 'RS256'
end
