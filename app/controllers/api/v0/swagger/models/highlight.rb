module Api::V0::Swagger::Models::Highlight
  include Swagger::Blocks
  include SwaggerBlocksExtensions

  swagger_schema :Highlight do
    key :required, [:id, :user_uuid]
  end

  swagger_schema :NewHighlight do
    key :required, [:user_uuid, :source_type, :source_id, :anchor, :highlighted_content, :color, :location_strategies]

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
      key :pattern, '#?(?:[a-f0-9]{3}){1,2}'
    end
    property :location_strategies do
      key :type, :array
      items do
        key :type, :string
      end
    end
  end

  add_properties(:NewHighlight, :Highlight) do
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
end
