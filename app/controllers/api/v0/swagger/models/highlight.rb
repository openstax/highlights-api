module Api::V0::Swagger::Models::Highlight
  include Swagger::Blocks
  include OpenStax::Swagger::SwaggerBlocksExtensions

  swagger_schema :TextPositionSelector do
    key :required, [:type, :start, :end]
    property :start do
      key :type, :string
    end
    property :end do
      key :type, :string
    end
    property :type do
      key :type, :string
    end
  end

  swagger_schema :XpathRangeSelector do
    key :required, [:endContainer, :endOffset, :startContainer, :startOffset, :type]
    property :endContainer do
      key :type, :string
    end
    property :endOffset do
      key :type, :integer
    end
    property :startContainer do
      key :type, :string
    end
    property :startOffset do
      key :type, :integer
    end
    property :type do
      key :type, :string
    end
  end

  swagger_schema :Highlight do
    key :required, [:id]
  end

  swagger_schema :NewHighlight do
    key :required, [:source_type, :source_id, :anchor, :highlighted_content, :color, :location_strategies]

    property :source_type do
      key :type, :string
      key :enum, ['openstax_page']
    end
    property :source_id do
      key :type, :string
    end
    property :anchor do
      key :type, :string
    end
    property :highlighted_content do
      key :type, :string
    end
    property :color do
      key :type, :string
      # remove the anchors because swagger-codegen always escapes them
      key :pattern, ::Highlight::VALID_COLOR.inspect[1..-2]
    end
    property :location_strategies do
      key :type, :array
      items do
        key :type, :object
      end
    end
  end

  add_properties(:NewHighlight, :Highlight) do
    property :id do
      key :type, :string
      key :format, 'uuid'
    end
  end
end
