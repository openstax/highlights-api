class Api::V0::BaseController < ApplicationController
  include Swagger::Blocks
  include OpenStax::Swagger::Bind

  rescue_from_unless_local StandardError, send_to_sentry: true do |ex|
    render json: binding_error(status_code: 500, messages: [ex.message]), status: 500
  end

  rescue_from ActiveRecord::RecordNotFound do |ex|
    render json: binding_error(status_code: 404, messages: [ex.message]), status: 404
  end

  rescue_from ActiveRecord::RecordInvalid, ActionController::ParameterMissing do |ex|
    render json: binding_error(status_code: 422, messages: [ex.message]), status: 422
  end

  protected

  def binding_error(status_code:, messages:)
    Api::V0::Bindings::Error.new(status_code: status_code, messages: messages)
  end
end
