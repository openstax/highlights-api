class Api::V0::BaseController < ApplicationController
  include Swagger::Blocks
  include OpenStax::Swagger::Bind

  rescue_from_unless_local StandardError do |ex|
    render json: binding_error(status_code: 500, messages: [ex.message]), status: 500
  end

  rescue_from_unless_local ActiveRecord::RecordNotFound do |ex|
    head :not_found
  end

  rescue_from_unless_local ActiveRecord::RecordInvalid, ActionController::ParameterMissing do |ex|
    render json: binding_error(status_code: 422, messages: [ex.message]), status: 422
  end

  rescue_from_unless_local SecurityTransgression do |ex|
    head :forbidden
  end

  protected

  def binding_error(status_code:, messages:)
    Api::V0::Bindings::Error.new(status_code: status_code, messages: messages)
  end
end
