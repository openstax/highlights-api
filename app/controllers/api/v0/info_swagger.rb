class Api::V0::InfoSwagger
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

  swagger_path '/info' do
    operation :get do
      key :summary, 'Get info on highlights'
      key :description, 'Get info on highlights'
      key :operationId, 'info'
      response 200 do
        key :description, 'Success.  Returns basic highlights metrics.'
        schema do
          key :'$ref', :InfoResults
        end
      end
      extend Api::V0::SwaggerResponses::ServerError
    end
  end
end
