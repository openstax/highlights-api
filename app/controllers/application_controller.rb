class ApplicationController < ActionController::API

  protected

  include RescueFromUnlessLocal

  def current_user_uuid
    @current_user_uuid ||= begin
      if Rails.env.development? && ENV['STUBBED_USER_UUID']
        ENV['STUBBED_USER_UUID']
      else
        OpenStax::Accounts::Sso.user_uuid(request)
      end
    end
  end

  def render_unauthorized_if_no_current_user
    head :unauthorized if current_user_uuid.nil?
  end

end
