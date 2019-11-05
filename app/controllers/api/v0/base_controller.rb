class Api::V0::BaseController < ApplicationController
  include Swagger::Blocks
  include OpenStax::Swagger::Bind

  rescue_from_unless_local StandardError do |ex|
    render json: { message: ex.message }, status: :internal_server_error
  end

  rescue_from ActiveRecord::RecordNotFound do |ex|
    render json: { message: ex.message }, status: :not_found
  end

  rescue_from ActiveRecord::RecordInvalid, ActionController::ParameterMissing do |ex|
    render json: { message: ex.message }, status: :unprocessable_entity
  end

  protected

  def binding_error(status_code:, messages:)
    Api::V0::Bindings::Error.new(status_code: status_code, messages: messages)
  end
end
