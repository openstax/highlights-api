module Api::V0::Swagger::Models::Highlight
  include Swagger::Blocks
  include OpenStax::Swagger::SwaggerBlocksExtensions

  swagger_schema :TextPositionSelector do
    key :required, [:type, :start, :end]
    property :start do
      key :type, :string
      key :description, 'The start to the text position selector.'
    end
    property :end do
      key :type, :string
      key :description, 'The end to the text position selector.'
    end
    property :type do
      key :type, :string
      key :description, 'The type for the text position selector.'
    end
  end

  swagger_schema :XpathRangeSelector do
    key :required, [:endContainer, :endOffset, :startContainer, :startOffset, :type]
    property :endContainer do
      key :type, :string
      key :description, 'The end container for the xpath range selector.'
    end
    property :endOffset do
      key :type, :integer
      key :description, 'The end offset for the xpath range selector.'
    end
    property :startContainer do
      key :type, :string
      key :description, 'The start container for the xpath range selector.'
    end
    property :startOffset do
      key :type, :integer
      key :description, 'The start offset for the xpath range selector.'
    end
    property :type do
      key :type, :string
      key :description, 'The type for the xpath range selector.'
    end
  end

  swagger_schema :GetHighlights do
    key :required, [:source_type]
    property :page do
      key :type, :integer
      key :description, 'The page number of paginated results, one-indexed. Defaults to 1.'
    end
    property :per_page do
      key :type, :integer
      key :description, 'The number of highlights per page for paginated results. Defaults to 15.'
    end
    property :order do
      key :type, :string
      key :enum, %w[asc desc]
      key :description, 'The desired sort order on the highlight creation time. Defaults to asc.'
    end
  end

  swagger_schema :Highlight do
    key :required, [:id]
  end

  swagger_schema :Highlights do
    # organization from https://jsonapi.org/
    property :meta do
      property :page do
        key :type, :integer
        key :description, 'The response page number'
      end
      property :per_page do
        key :type, :integer
        key :description, 'The response per page'
      end
      property :total_count do
        key :type, :integer
        key :description, 'The number of returned highlights'
      end
    end
    property :data do
      key :type, :array
      key :description, 'The selected highlight(s)'
      items do
        key :'$ref', :Highlight
      end
    end
  end

  swagger_schema :NewHighlight do
    key :required, [:source_type, :source_id, :anchor, :highlighted_content, :color, :location_strategies]
  end

  add_properties(:GetHighlights, :NewHighlight, :Highlight) do
    property :source_type do
      key :type, :string
      key :enum, ['openstax_page']
      key :description, 'The source_type of the highlight, typically a openstax_page'
    end
    property :source_parent_ids do
      key :type, :array
      key :description, 'The parent ids of the highlight. For book highlights, ' \
                        'the parent_id could be a book, unit, or chapter ID uuid.'
      items do
        key :type, :string
      end
    end
    property :color do
      key :type, :string
      # remove the anchors because swagger-codegen always escapes them
      key :pattern, ::Highlight::VALID_COLOR.inspect[1..-2]
      key :description, 'The highlight color.'
    end
  end

  add_properties(:NewHighlight, :Highlight) do
    property :id do
      key :type, :string
      key :format, 'uuid'
      key :description, 'The highlight ID.'
    end
    property :source_id do
      key :type, :string
      key :description, 'The source_id of the highlight.'
    end
    property :anchor do
      key :type, :string
      key :description, 'The anchor of the highlight.'
    end
    property :highlighted_content do
      key :type, :string
      key :description, 'The highlighted content.'
    end
    property :location_strategies do
      key :type, :array
      key :description, 'Location strategies for the highlight. ' \
                        'Items should have a schema matching the strategy ' \
                        'schemas that have been defined'
      items do
        key :type, :object
      end
    end
  end
end
