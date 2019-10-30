class Api::V0::HighlightsController < Api::V0::BaseController
  # before_action :set_highlight, only: [:show, :update, :destroy]

  swagger_path '/highlights' do
    operation :post do
      key :summary, 'Add a highlight'
      key :description, 'Add a OpenStax highlight or note.'
      key :operationId, 'addHighlight'
      key :produces, [
        'application/json'
      ]
      key :tags, [
        'Highlights'
      ]
      # security do
      #   key :api_id, []
      # end
      parameter do
        key :name, :highlight
        key :in, :body
        key :description, 'The highlight data'
        key :required, true
        schema do
          key :'$ref', :NewHighlight
        end
      end
      response 200 do
        key :description, 'Success.  Returns the created highlights.'
        schema do
          key :'$ref', :Highlight
        end
      end
      extend Api::V0::SwaggerResponses::AuthenticationErrorId
      extend Api::V0::SwaggerResponses::ForbiddenErrorId
      extend Api::V0::SwaggerResponses::ServerError
    end
  end

  def create
    binding, error = bind(params.require(:highlight), Api::V0::Bindings::NewHighlight)
    render(json: error, status: error.status_code) and return if error

    @highlight = Highlight.create!(highlight_params)
    render json: @highlight, status: :created
  end

  private

  def highlight_params
    params.require(:highlight).permit(:user_uuid, :source_type, :source_id, :source_metadata,
                                      :source_parent_ids, :anchor, :highlighted_content, :annotation,
                                      :color, :source_order, :order_in_source, :location_strategies => [])
  end

  def set_highlight
    @highlight = Highlight.find(params[:id])
  end
end
