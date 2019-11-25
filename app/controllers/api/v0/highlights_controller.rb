class Api::V0::HighlightsController < Api::V0::BaseController
  before_action :render_unauthorized_if_no_current_user

  before_action :get_highlight, only: [:update, :destroy]

  # See Api::V0::HighlightsSwagger for documentation

  def create
    inbound_binding, error = bind(params.require(:highlight), Api::V0::Bindings::NewHighlight)
    render(json: error, status: error.status_code) and return if error

    ServiceLimits.create_check(current_user_uuid, inbound_binding) do |binding|
      model = binding.create_model!(user_id: current_user_uuid)
    end

    response_binding = Api::V0::Bindings::Highlight.create_from_model(model)
    render json: response_binding, status: :created
  end

  def index
    inbound_binding, error = bind(query_parameters, Api::V0::Bindings::GetHighlightsParameters)
    render(json: error, status: error.status_code) and return if error

    query_result = inbound_binding.query(user_id: current_user_uuid)

    ServiceLimits.get_check(query_result) do |query_result|
      response_binding = Api::V0::Bindings::Highlights.create_from_query_result(query_result)
      render json: response_binding, status: :ok
    end
  end

  def summary
    inbound_binding, error = bind(request.query_parameters,
                                  Api::V0::Bindings::GetHighlightsSummaryParameters)
    render(json: error, status: error.status_code) and return if error

    summary_result = inbound_binding.summarize(user_uuid: current_user_uuid)

    response_binding = Api::V0::Bindings::HighlightsSummary.create_from_summary_result(summary_result)
    render json: response_binding, status: :ok
  end

  def update
    inbound_binding, error = bind(params.require(:highlight), Api::V0::Bindings::HighlightUpdate)
    render(json: error, status: error.status_code) and return if error

    ServiceLimits.update_check(current_user_uuid, inbound_binding) do |binding|
      model = binding.update_model!(@highlight)
    end

    response_binding = Api::V0::Bindings::Highlight.create_from_model(model)
    render json: response_binding, status: :ok
  end

  def destroy
    ServiceLimits.delete_reset(current_user_uuid, @highlight, &:destroy!)

    head :ok
  end

  private

  def get_highlight
    @highlight = Highlight.find(params[:id])
    raise SecurityTransgression unless @highlight.user_id == current_user_uuid
  end

  def query_parameters
    request.query_parameters.tap do |parameters|
      # Swagger-codegen clients can't make the x[]=entry1&x[]=entry2 query parameter array
      # syntax, which means we have to use an alternate serialization of an array.  For
      # source_ids we use CSV; here we do the comma splitting.
      parameters["source_ids"] = parameters["source_ids"].split(',') if parameters["source_ids"].is_a?(String)
    end
  end

end
