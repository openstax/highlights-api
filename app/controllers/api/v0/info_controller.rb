class Api::V0::InfoController < Api::V0::BaseController
  before_action :render_unauthorized_unless_current_user_authorized

  swagger_path '/info' do
    operation :get do
      key :summary, 'Get info on highlights'
      key :description, 'Get info on highlights'
      key :operationId, 'info'
      response 200 do
        key :description, 'Success.  Returns basic highlights metrics.'
        schema do
          key :'$ref', :Info
        end
      end
      extend Api::V0::SwaggerResponses::ServerError
    end
  end

  def info
    started_at = Time.now
    info_data = HighlightsInfo.new.call

    response = Api::V0::Bindings::InfoResults.new.build_from_hash(info_data.with_indifferent_access)

    response.overall_took_ms = ((Time.now - started_at)*1000).round

    render json: response, status: :ok
  end

  private

  def render_unauthorized_unless_current_user_authorized
    head :unauthorized unless current_user_authorized?
  end

  def current_user_authorized?
    # current_user_uuid
    # JP: we need a list of authorized UUIDs somewhere
    # we could get the UUIDs for you me kim tom from accounts-dev, -qa, -staging,
    # -production and put them in the parameter store, copy them into an env var
    # on the server and then check current_user_uuid against that
    true
  end
end
