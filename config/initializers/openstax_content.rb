content_secrets = Rails.application.secrets.content

OpenStax::Content.configure do |config|
  config.archive_path = content_secrets[:archive_path]
  config.domain = content_secrets[:domain]
  config.logger = Rails.logger
end
