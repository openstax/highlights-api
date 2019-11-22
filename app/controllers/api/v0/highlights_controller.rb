class Api::V0::HighlightsController < Api::V0::BaseController
  before_action :render_unauthorized_if_no_current_user

  before_action :get_highlight, only: [:update, :destroy]

  # See Api::V0::HighlightsSwagger for documentation

  def create
    inbound_binding, error = bind(params.require(:highlight), Api::V0::Bindings::NewHighlight)
    render(json: error, status: error.status_code) and return if error

    model = inbound_binding.create_model!(user_uuid: current_user_uuid)

    response_binding = Api::V0::Bindings::Highlight.create_from_model(model)
    render json: response_binding, status: :created
  end

  def index
    inbound_binding, error = bind(request.query_parameters, Api::V0::Bindings::GetHighlights)
    render(json: error, status: error.status_code) and return if error

    query_result = inbound_binding.query(user_uuid: current_user_uuid)

    response_binding = Api::V0::Bindings::Highlights.create_from_query_result(query_result)
    render json: response_binding, status: :ok
  end

  def update
    inbound_binding, error = bind(params.require(:highlight), Api::V0::Bindings::HighlightUpdate)
    render(json: error, status: error.status_code) and return if error

    model = inbound_binding.update_model!(@highlight)

    response_binding = Api::V0::Bindings::Highlight.create_from_model(model)
    render json: response_binding, status: :ok
  end

  def destroy
    @highlight.destroy!
    head :ok
  end

  private

  def get_highlight
    @highlight = Highlight.find(params[:id])
    raise SecurityTransgression unless @highlight.user_uuid == current_user_uuid
  end

end
