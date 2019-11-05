class ApplicationController < ActionController::API

  include RescueFromUnlessLocal

  def current_user_uuid
    if Rails.environment.development? && ENV['FORCED_USER_UUID']
      ENV['FORCED_USER_UUID']
    else
      OpenStax::Accounts::Sso.user_uuid(request)
    end
  end

end
