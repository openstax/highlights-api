class Api::V0::HighlightsSwagger
  include Swagger::Blocks
  include OpenStax::Swagger::SwaggerBlocksExtensions

  DEFAULT_HIGHLIGHTS_PER_PAGE = 15
  MAX_HIGHLIGHTS_PER_PAGE = 200
  DEFAULT_HIGHLIGHTS_PAGE = 1

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

  def self.swagger_path_and_binding(path, &block)
    swagger_path(path, &block).tap do |path_node|
      if path_node.data[:operationId].blank?
        raise "Must set an operationId when generating a binding from a swagger_path"
      end

      binding_name = path_node.data[:operationId].camelcase
      required_keys = []

      swagger_schema binding_name do
        path_node.data[:parameters].map(&:data).each do |parameter_hash|
          parameter_hash.symbolize_keys!
          required_keys.push(parameter_hash[:name]) if parameter_hash.delete(:required)
          property parameter_hash[:name] do
            parameter_hash.except(:in, :name).each do |key, value|
              key key, value
            end
          end
        end
        key :required, required_keys
      end
    end
  end

  swagger_path_and_binding '/highlights' do
    operation :get do
      key :summary, 'Get filtered highlights'
      key :description, <<~DESC
        Get filtered highlights belonging to the calling user.

        Highlights can be filtered thru query parameters:  source_type,
        scope_id, source_ids, and color.

        Results are paginated and ordered.  When source_ids are specified, the order is order
        within the sources.  When source_ids are not specified, the order is by creation time.

        Example call:
          /api/v0/highlights?source_type=openstax_page&scope_id=123&color=#ff0000
      DESC
      key :operationId, 'getHighlights'
      key :produces, [
        'application/json'
      ]
      key :tags, [
        'Highlights'
      ]
      parameter do
        key :name, :source_type
        key :in, :query
        key :type, :string
        key :required, true
        key :enum, ['openstax_page']
        key :description, 'Limits results to those highlights made in sources of this type.'
      end
      parameter do
        key :name, :scope_id
        key :in, :query
        key :type, :string
        key :required, false
        key :description, 'Limits results to the source document container in which the highlight ' \
                          'was made.  For openstax_page source_types, this is a versionless book UUID. ' \
                          'If this is not specified, results across scopes will be returned, meaning ' \
                          'the order of the results will not be meaningful.'
      end
      parameter do
        key :name, :source_ids
        key :in, :query
        key :type, :array
        key :required, false
        key :description, 'One or more source IDs; query results will contain highlights ordered '\
                          'by the order of these source IDs and ordered within each source.  If ' \
                          'parameter is an empty array, no results will be returned.  If the ' \
                          'parameter is not provided, all highlights under the scope will be ' \
                          'returned.'
        items do
          key :type, :string
        end
      end
      parameter do
        key :name, :color
        key :in, :query
        key :type, :string
        key :required, false
        key :pattern, ::Highlight::VALID_COLOR.inspect
        key :description, 'Limits results to this highlight color.'
      end
      parameter do
        key :name, :page
        key :in, :query
        key :type, :integer
        key :required, false
        key :description, 'The page number of paginated results, one-indexed.'
        key :minimum, 1
        key :default, DEFAULT_HIGHLIGHTS_PAGE
      end
      parameter do
        key :name, :per_page
        key :in, :query
        key :type, :integer
        key :required, false
        key :description, 'The number of highlights per page for paginated results.'
        key :minimum, 0
        key :maximum, MAX_HIGHLIGHTS_PER_PAGE
        key :default, DEFAULT_HIGHLIGHTS_PER_PAGE
      end
      response 200 do
        key :description, 'Success.  Returns the filtered highlights.'
        schema do
          key :'$ref', :Highlights
        end
      end
      extend Api::V0::SwaggerResponses::AuthenticationError
      extend Api::V0::SwaggerResponses::UnprocessableEntityError
      extend Api::V0::SwaggerResponses::ServerError
    end
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
end
