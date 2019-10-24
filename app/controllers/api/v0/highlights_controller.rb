class Api::V0::HighlightsController < Api::V0::BaseController
  # before_action :set_highlight, only: [:show, :update, :destroy]

  def create
    @highlight = Highlight.create!(highlight_params)
    render json: @highlight, status: :created
  end

  private

  def highlight_params
    params.require(:highlight).permit(:user_uuid, :source_type, :source_id, :source_metadata,
                  :source_parent_ids, :anchor, :highlighted_content, :annotation,
                  :color, :source_order, :order_in_source, :location_strategies)
  end

  def set_highlight
    @highlight = Highlight.find(params[:id])
  end
end
