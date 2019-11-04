class Api::V0::HighlightsController < Api::V0::BaseController
  # before_action :set_highlight, only: [:show, :update, :destroy]

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
      extend Api::V0::SwaggerResponses::AuthenticationErrorId
      extend Api::V0::SwaggerResponses::UnprocessableEntityError
      extend Api::V0::SwaggerResponses::ServerError
    end
  end

  def create
    binding, error = bind(params.require(:highlight), Api::V0::Bindings::NewHighlight)
    render(json: error, status: error.status_code) and return if error

    # temporary test user_uuid.  will be removed when auth is set up
    temp_user_uuid = '55783d49-7562-4576-a626-3b877557a21f'
    created_highlight = Highlight.create!(binding.to_hash.merge(user_uuid: temp_user_uuid))

    response_binding = Api::V0::Bindings::Highlight.create_from_model(created_highlight)
    render json: response_binding.to_hash, status: :created
  end

  private

  def set_highlight
    @highlight = Highlight.find(params[:id])
  end
end
