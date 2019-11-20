class Api::V0::InfoController < Api::V0::BaseController
  before_action :validate_current_user_authorized_as_admin

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
end
