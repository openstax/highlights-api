module Api::V0::Swagger::Models::Highlight
  include Swagger::Blocks
  include SwaggerBlocksExtensions

  swagger_component do
    schema :Highlight do
      key :required, [:id, :user_uuid]
      property :id do
        key :type, :string
        key :format, 'uuid'
        key :readOnly, true
        key :description, 'Internally set UUID'
      end
      property :user_uuid do
        key :type, :string
        key :format, 'uuid'
        key :description, 'The ID of the user accessing the highlight'
      end
    end

    schema :TextLocationStrategy do
      property :strategy do
        key :type, :string
        key :description, 'text location strategy'
      end
    end

    schema :XPathLocationStrategy do
      property :strategy do
        key :type, :string
        key :description, 'text location strategy'
      end
    end

    schema :LocationStrategy do
      one_of do
        key :'$ref', :TextLocationStrategy
        key :'$ref', :XPathLocationStrategy
      end
    end

    schema :NewHighlight do
      allOf do
        schema do
          key :'$ref', :Highlight
        end
        schema do
          key :required, [:source_type, :source_id, :anchor, :highlighted_content, :color, :location_strategies]
          property :source_type do
            key :type, :string
            key :enum, ['openstax_page']
          end
          property :source_id do
            key :type, :string
            key :format, 'uuid'
          end
          property :anchor do
            key :type, :string
          end
          property :highlighted_content do
            key :type, :string
          end
          property :color do
            key :type, :string
          end
          property :location_strategies do
            key :type, :array
            items do
              key :'$ref', :LocationStrategy
            end
          end
        end
      end
    end
  end
end
