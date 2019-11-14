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
      key :summary, 'Get selected highlights'
      key :description, <<~DESC
        Get selected highlight(s) belonging to the calling user.

        Highlights can be filtered thru query parameters:  source_type,
        source_parent_ids, and color.

        Highlights are always paginated.  Pass in page and per_page to
        request specific page, or omit the pagination params to get the defaults
        of page = 1 and per_page of 15.

        Example call:
          /api/v0/highlights?source_type=”openstax_page”&\
            source_parent_id=[“123”]&color=#ff0000&page=1&per_page=20&order=desc
      DESC
      key :operationId, 'getHighlights'
      key :produces, [
        'application/json'
      ]
      key :tags, [
        'Highlights'
      ]
      parameter do
        key :name, :get_highlights
        key :in, :query
        key :description, 'The get highlight query parameters'
        key :required, true
        schema do
          key :'$ref', :GetHighlights
        end
      end
      response 200 do
        key :description, 'Returns the desired highlight(s).'
        schema do
          key :'$ref', :Highlights
        end
      end
      extend Api::V0::SwaggerResponses::AuthenticationError
      extend Api::V0::SwaggerResponses::UnprocessableEntityError
      extend Api::V0::SwaggerResponses::ServerError
    end
  end

  def index
    inbound_binding, error = bind(request.query_parameters, Api::V0::Bindings::GetHighlights)
    render(json: error, status: error.status_code) and return if error

    selected_highlights, pagination_used, total_count = inbound_binding.query(user_uuid: current_user_uuid)

    response_binding = Api::V0::Bindings::Highlights.create_from_models(selected_highlights,
                                                                        pagination_used,
                                                                        total_count)
    render json: response_binding, status: :ok
  end

  swagger_path '/highlights/{id}' do
    operation :put do
      key :summary, 'Update a highlight'
      key :description, 'Update a highlight'
      key :operationId, 'updateHighlight'
      key :produces, [
        'application/json'
      ]
      key :tags, [
        'Highlights'
      ]
      parameter do
        key :name, :id
        key :in, :path
        key :description, 'ID of the highlight to update.'
        key :required, true
        key :type, :string
        key :format, 'uuid'
      end
      parameter do
        key :name, :highlight
        key :in, :body
        key :description, 'The highlight updates.'
        key :required, true
        schema do
          key :'$ref', :HighlightUpdate
        end
      end
      response 200 do
        key :description, 'Success.  Returns the updated highlight.'
        schema do
          key :'$ref', :Highlight
        end
      end
      extend Api::V0::SwaggerResponses::AuthenticationError
      extend Api::V0::SwaggerResponses::UnprocessableEntityError
      extend Api::V0::SwaggerResponses::ServerError
    end
  end

  def update
    inbound_binding, error = bind(params.require(:highlight), Api::V0::Bindings::UpdateHighlight)
    render(json: error, status: error.status_code) and return if error

    model = inbound_binding.update_model!(@highlight)

    response_binding = Api::V0::Bindings::Highlight.create_from_model(model)
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
