class Api::V0::DiagnosticsController < Api::V0::BaseController
  before_action :validate_current_user_authorized_as_admin

  # Forcing an exception
  def exception
    raise "An exception for diagnostic purposes"
  end

  # Forcing a status code response
  def status_code
    head params[:status_code]
  end

  # Showing whether Accounts integration is working
  def me
    render json: { uuid: current_user_uuid }
  end

end
