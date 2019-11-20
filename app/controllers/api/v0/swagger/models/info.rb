module Api::V0::Swagger::Models::Info
  include Swagger::Blocks
  include OpenStax::Swagger::SwaggerBlocksExtensions

  swagger_schema :InfoData do
    property :total_highlights do
      key :type, :integer
      key :description, "The total number of highlights"
    end
    property :avg_highlights_per_user do
      key :type, :integer
      key :description, "The average number of highlights per user"
    end
    property :max_num_highlights_any_user do
      key :type, :integer
      key :description, "The max number of highlights used by any one user"
    end
    property :total_notes do
      key :type, :integer
      key :description, "The total number of notes/annotations"
    end
    property :avg_note_length do
      key :type, :integer
      key :description, "The average length (chars) of a note"
    end
  end

  swagger_schema :InfoResults do
    key :required, [:overall_took, :postgres_version]
    property :overall_took_ms do
      key :type, :integer
      key :readOnly, true
      key :description, "How long the request took (ms)"
    end
    property :postgres_version do
      key :type, :string
      key :readOnly, true
      key :description, "Current version of Postgres"
    end
    property :data do
      key :'$ref', :InfoData
    end
  end
end
