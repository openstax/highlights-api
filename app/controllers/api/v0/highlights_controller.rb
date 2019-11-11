class Api::V0::HighlightsController < Api::V0::BaseController
  before_action :render_unauthorized_if_no_current_user

  before_action :get_highlight, only: [:update, :destroy]

  swagger_path '/highlights' do
    operation :post do
      key :summary, 'Add a highlight'
      key :description, 'Add a highlight with an optional note'
      key :operationId, 'addHighlight'
      key :produces, [
        'application/json'
      ]
      key :tags, [
        'Highlights'
      ]
      # security do
      #   key :api_id, []
      # end
      parameter do
        key :name, :highlight
        key :in, :body
        key :description, 'The highlight data'
        key :required, true
        schema do
          key :'$ref', :NewHighlight
        end
      end
      response 201 do
        key :description, 'Created.  Returns the created highlight.'
        schema do
          key :'$ref', :Highlight
        end
      end
      extend Api::V0::SwaggerResponses::AuthenticationError
      extend Api::V0::SwaggerResponses::UnprocessableEntityError
      extend Api::V0::SwaggerResponses::ServerError
    end
  end

  def create
    inbound_binding, error = bind(params.require(:highlight), Api::V0::Bindings::NewHighlight)
    render(json: error, status: error.status_code) and return if error

    model = inbound_binding.create_model!(user_uuid: current_user_uuid)

    response_binding = Api::V0::Bindings::Highlight.create_from_model(model)
    render json: response_binding, status: :created
  end

  swagger_path '/highlights' do
    operation :get do
      key :summary, 'Get the highlight(s)'
      key :description, 'Get the highlight(s) for the owner.'
      key :operationId, 'getHighlights'
      key :produces, [
        'application/json'
      ]
      key :tags, [
        'Highlights'
      ]
      # security do
      #   key :api_id, []
      # end
      parameter do
        key :name, :get_highlights
        key :in, :query
        key :description, 'The get highlight query parameters'
        key :required, true
        schema do
          key :'$ref', :GetHighlights
        end
      end
      response 201 do
        key :description, 'Returns the desired highlight(s).'
        schema do
          key :'$ref', :Highlights
        end
      end
      extend Api::V0::SwaggerResponses::AuthenticationError
      extend Api::V0::SwaggerResponses::ForbiddenError
      extend Api::V0::SwaggerResponses::UnprocessableEntityError
      extend Api::V0::SwaggerResponses::ServerError
    end
  end

  # Get highlights
  # Example call:
  #      /api/v0/highlights?source_type=”openstax_page”&source_parent_id=[“123”]&
  #         color=#ff0000&page=1&per_page=20&order=desc
  def index
    inbound_binding, error = bind(request.query_parameters, Api::V0::Bindings::GetHighlights)
    render(json: error, status: error.status_code) and return if error

    highlights = inbound_binding.query(user_uuid: current_user_uuid)

    response_binding = Api::V0::Bindings::Highlights.create_from_model(highlights)
    render json: response_binding, status: :ok
  end

  swagger_path '/highlights/{id}' do
    operation :delete do
      key :summary, 'Delete a highlight'
      key :description, 'Delete a highlight. Can only be done by the owner of the highlight.'
      key :operationId, 'deleteHighlight'
      key :tags, [
        'Highlights'
      ]
      # security do
      #   key :api_id, []
      # end
      parameter do
        key :name, :id
        key :in, :path
        key :description, 'ID of the highlight to delete'
        key :required, true
        key :type, :string
        key :format, 'uuid'
      end
      response 200 do
        key :description, 'Deleted.'
      end
      extend Api::V0::SwaggerResponses::AuthenticationError
      extend Api::V0::SwaggerResponses::ForbiddenError
      extend Api::V0::SwaggerResponses::NotFoundError
      extend Api::V0::SwaggerResponses::ServerError
    end
  end

  def destroy
    @highlight.destroy!
    head :ok
  end

  private

  def get_highlight
    @highlight = Highlight.find(params[:id])
    raise SecurityTransgression unless @highlight.user_uuid == current_user_uuid
  end

end
