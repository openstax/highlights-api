class Api::V0::DiagnosticsController < Api::V0::BaseController

  def exception
    raise "An exception for diagnostic purposes"
  end

  def status_code
    head params[:status_code]
  end

end
