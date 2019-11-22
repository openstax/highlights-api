class Api::V0::HighlightsController < Api::V0::BaseController
  before_action :render_unauthorized_if_no_current_user

  before_action :get_highlight, only: [:update, :destroy]

  # swagger_path '/highlights' do
  #   operation :post do
  #     key :summary, 'Add a highlight'
  #     key :description, 'Add a highlight with an optional note'
  #     key :operationId, 'addHighlight'
  #     key :produces, [
  #       'application/json'
  #     ]
  #     key :tags, [
  #       'Highlights'
  #     ]
  #     parameter do
  #       key :name, :highlight
  #       key :in, :body
  #       key :description, 'The highlight data'
  #       key :required, true
  #       schema do
  #         key :'$ref', :NewHighlight
  #       end
  #     end
  #     response 201 do
  #       key :description, 'Created.  Returns the created highlight.'
  #       schema do
  #         key :'$ref', :Highlight
  #       end
  #     end
  #     extend Api::V0::SwaggerResponses::AuthenticationError
  #     extend Api::V0::SwaggerResponses::UnprocessableEntityError
  #     extend Api::V0::SwaggerResponses::ServerError
  #   end
  # end

  def create
    inbound_binding, error = bind(params.require(:highlight), Api::V0::Bindings::NewHighlight)
    render(json: error, status: error.status_code) and return if error

    model = inbound_binding.create_model!(user_uuid: current_user_uuid)

    response_binding = Api::V0::Bindings::Highlight.create_from_model(model)
    render json: response_binding, status: :created
  end

  # swagger_path '/highlights' do
  #   operation :get do
  #     key :summary, 'Get filtered highlights'
  #     key :description, <<~DESC
  #       Get filtered highlights belonging to the calling user.

  #       Highlights can be filtered thru query parameters:  source_type,
  #       scope_id, source_ids, and color.

  #       Results are paginated and ordered.  When source_ids are specified, the order is order
  #       within the sources.  When source_ids are not specified, the order is by creation time.

  #       Example call:
  #         /api/v0/highlights?source_type=openstax_page&scope_id=123&color=#ff0000
  #     DESC
  #     key :operationId, 'getHighlights'
  #     key :produces, [
  #       'application/json'
  #     ]
  #     key :tags, [
  #       'Highlights'
  #     ]
  #     debugger
  #     # parameter do
  #     #   key :name, :source_type
  #     #   key :in, :query
  #     #   key :type, :string
  #     #   key :required, true
  #     #   key :enum, ['openstax_page']
  #     #   key :description, 'Limits results to those highlights made in sources of this type.'
  #     # end
  #     # parameter do
  #     #   key :name, :scope_id
  #     #   key :in, :query
  #     #   key :type, :string
  #     #   key :required, false
  #     #   key :description, 'Limits results to the source document container in which the highlight ' \
  #     #                     'was made.  For openstax_page source_types, this is a versionless book UUID. ' \
  #     #                     'If this is not specified, results across scopes will be returned, meaning ' \
  #     #                     'the order of the results will not be meaningful.'
  #     # end
  #     # parameter do
  #     #   key :name, :source_ids
  #     #   key :in, :query
  #     #   key :type, :array
  #     #   key :required, false
  #     #   key :description, 'One or more source IDs; query results will contain highlights ordered '\
  #     #                     'by the order of these source IDs and ordered within each source.  If ' \
  #     #                     'parameter is an empty array, no results will be returned.  If the ' \
  #     #                     'parameter is not provided, all highlights under the scope will be ' \
  #     #                     'returned.'
  #     #   items do
  #     #     key :type, :string
  #     #   end
  #     # end
  #     # parameter do
  #     #   key :name, :color
  #     #   key :in, :query
  #     #   key :type, :string
  #     #   key :required, false
  #     #   key :pattern, ::Highlight::VALID_COLOR.inspect
  #     #   key :description, 'Limits results to this highlight color.'
  #     # end
  #     # parameter do
  #     #   key :name, :page
  #     #   key :in, :query
  #     #   key :type, :integer
  #     #   key :required, false
  #     #   key :description, 'The page number of paginated results, one-indexed.'
  #     #   key :minimum, 1
  #     #   key :default, ::Api::V0::Swagger::Models::Highlight::DEFAULT_HIGHLIGHTS_PAGE
  #     # end
  #     # parameter do
  #     #   key :name, :per_page
  #     #   key :in, :query
  #     #   key :type, :integer
  #     #   key :required, false
  #     #   key :description, 'The number of highlights per page for paginated results.'
  #     #   key :minimum, 0
  #     #   key :maximum, ::Api::V0::Swagger::Models::Highlight::MAX_HIGHLIGHTS_PER_PAGE
  #     #   key :default, ::Api::V0::Swagger::Models::Highlight::DEFAULT_HIGHLIGHTS_PER_PAGE
  #     # end
  #     response 200 do
  #       key :description, 'Success.  Returns the filtered highlights.'
  #       schema do
  #         key :'$ref', :Highlights
  #       end
  #     end
  #     extend Api::V0::SwaggerResponses::AuthenticationError
  #     extend Api::V0::SwaggerResponses::UnprocessableEntityError
  #     extend Api::V0::SwaggerResponses::ServerError
  #   end
  # end

  def index
    inbound_binding, error = bind(request.query_parameters, Api::V0::Bindings::GetHighlights)
    render(json: error, status: error.status_code) and return if error

    query_result = inbound_binding.query(user_uuid: current_user_uuid)

    response_binding = Api::V0::Bindings::Highlights.create_from_query_result(query_result)
    render json: response_binding, status: :ok
  end

  # swagger_path '/highlights/{id}' do
  #   operation :put do
  #     key :summary, 'Update a highlight'
  #     key :description, 'Update a highlight'
  #     key :operationId, 'updateHighlight'
  #     key :produces, [
  #       'application/json'
  #     ]
  #     key :tags, [
  #       'Highlights'
  #     ]
  #     parameter do
  #       key :name, :id
  #       key :in, :path
  #       key :description, 'ID of the highlight to update.'
  #       key :required, true
  #       key :type, :string
  #       key :format, 'uuid'
  #     end
  #     parameter do
  #       key :name, :highlight
  #       key :in, :body
  #       key :description, 'The highlight updates.'
  #       key :required, true
  #       schema do
  #         key :'$ref', :HighlightUpdate
  #       end
  #     end
  #     response 200 do
  #       key :description, 'Success.  Returns the updated highlight.'
  #       schema do
  #         key :'$ref', :Highlight
  #       end
  #     end
  #     extend Api::V0::SwaggerResponses::AuthenticationError
  #     extend Api::V0::SwaggerResponses::UnprocessableEntityError
  #     extend Api::V0::SwaggerResponses::ServerError
  #   end
  # end

  def update
    inbound_binding, error = bind(params.require(:highlight), Api::V0::Bindings::HighlightUpdate)
    render(json: error, status: error.status_code) and return if error

    model = inbound_binding.update_model!(@highlight)

    response_binding = Api::V0::Bindings::Highlight.create_from_model(model)
    render json: response_binding, status: :ok
  end

  # swagger_path '/highlights/{id}' do
  #   operation :delete do
  #     key :summary, 'Delete a highlight'
  #     key :description, 'Delete a highlight. Can only be done by the owner of the highlight.'
  #     key :operationId, 'deleteHighlight'
  #     key :tags, [
  #       'Highlights'
  #     ]
  #     parameter do
  #       key :name, :id
  #       key :in, :path
  #       key :description, 'ID of the highlight to delete'
  #       key :required, true
  #       key :type, :string
  #       key :format, 'uuid'
  #     end
  #     response 200 do
  #       key :description, 'Deleted.'
  #     end
  #     extend Api::V0::SwaggerResponses::AuthenticationError
  #     extend Api::V0::SwaggerResponses::ForbiddenError
  #     extend Api::V0::SwaggerResponses::NotFoundError
  #     extend Api::V0::SwaggerResponses::ServerError
  #   end
  # end

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
