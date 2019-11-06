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

  # /api/v0/highlights?source_type=”openstax_page”& source_parent_id=[“123”]&color=#ff0000&page=1&per_page=20&order=X
  #   (or query by `source_id=blah` for all highlights on one book page, e.g.)
  def index
    #temp for now, until using bindings
    filter = HighlightFilter.new(user_id: current_user_uuid, params: params.permit!)

    render json: filter.call, status: :ok
  end

  def create
    inbound_binding, error = bind(params.require(:highlight), Api::V0::Bindings::NewHighlight)
    render(json: error, status: error.status_code) and return if error

    model = inbound_binding.create_model!(user_uuid: current_user_uuid)

    response_binding = Api::V0::Bindings::Highlight.create_from_model(model)
    render json: response_binding, status: :created
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
