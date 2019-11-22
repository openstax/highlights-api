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
    key :required, [:end_container, :end_offset, :start_container, :start_offset, :type]
    property :end_container do
      key :type, :string
      key :description, 'The end container for the xpath range selector.'
    end
    property :end_offset do
      key :type, :integer
      key :description, 'The end offset for the xpath range selector.'
    end
    property :start_container do
      key :type, :string
      key :description, 'The start container for the xpath range selector.'
    end
    property :start_offset do
      key :type, :integer
      key :description, 'The start offset for the xpath range selector.'
    end
    property :type do
      key :type, :string
      key :description, 'The type for the xpath range selector.'
    end
  end

  swagger_schema :Highlights do
    # organization from https://jsonapi.org/
    property :meta do
      property :page do
        key :type, :integer
        key :description, 'The current page number for these paginated results, one-indexed.'
      end
      property :per_page do
        key :type, :integer
        key :description, 'The requested number of results per page.'
      end
      property :count do
        key :type, :integer
        key :description, 'The number of results in the current page.'
      end
      property :total_count do
        key :type, :integer
        key :description, 'The number of results across all pages.'
      end
    end
    property :data do
      key :type, :array
      key :description, 'The filtered highlights.'
      items do
        key :'$ref', :Highlight
      end
    end
  end

  swagger_schema :Highlight do
    key :required, [:id]
  end

  swagger_schema :NewHighlight do
    key :required, [:source_type, :source_id, :anchor, :highlighted_content, :color, :location_strategies]
  end

  add_properties(:Highlight, :NewHighlight) do
    property :id do
      key :type, :string
      key :format, 'uuid'
      key :description, 'The highlight ID.'
    end
    property :source_type do
      key :type, :string
      key :enum, ['openstax_page']
      key :description, 'The type of content that contains the highlight.'
    end
    property :source_id do
      key :type, :string
      key :description, 'The ID of the source document in which the highlight is made.  ' \
                        'Has source_type-specific constraints (e.g. all lowercase UUID for ' \
                        'the \'openstax_page\' source_type).'
    end
    property :scope_id do
      key :type, :string
      key :description, 'The ID of the container for the source in which the highlight is made.  ' \
                        'Varies depending on source_type (e.g. is the lowercase, versionless ' \
                        'book UUID for the \'openstax_page\' source_type).'
    end
    property :prev_highlight_id do
      key :type, :string
      key :format, 'uuid'
      key :description, 'The ID of the highlight immediately before this highlight.  May be ' \
                        'null if there are no preceding highlights in this source.'
    end
    property :next_highlight_id do
      key :type, :string
      key :format, 'uuid'
      key :description, 'The ID of the highlight immediately after this highlight.  May be ' \
                        'null if there are no following highlights in this source.'
    end
    property :color do
      key :type, :string
      key :pattern, ::Highlight::VALID_COLOR.inspect
      key :description, 'The highlight color.'
    end
    property :anchor do
      key :type, :string
      key :description, 'The anchor of the highlight.'
    end
    property :highlighted_content do
      key :type, :string
      key :description, 'The highlighted content.'
    end
    property :annotation do
      key :type, :string
      key :description, 'The note attached to the highlight.'
    end
    property :location_strategies do
      key :type, :array
      key :description, 'Location strategies for the highlight. ' \
                        'Items should have a schema matching the strategy ' \
                        'schemas that have been defined.'
      items do
        key :type, :object
      end
    end
  end

  add_properties(:Highlight) do
    property :order_in_source do
      key :type, :number
      key :readOnly, true
      key :description, 'A number whose relative value gives the highlight\'s order within the ' \
                        'source. Its value has no meaning on its own.'
    end
  end

  swagger_schema :HighlightUpdate do
    property :color do
      key :type, :string
      key :pattern, ::Highlight::VALID_COLOR.inspect
      key :description, 'The new highlight color.'
    end
    property :annotation do
      key :type, :string
      key :description, 'The new note for the highlight (replaces existing note).'
    end
  end
end
