# The primary controller for this API that implements CRUD for highlights
#
# See Api::V0::HighlightsSwagger for documentation
class Api::V0::HighlightsController < Api::V0::BaseController
  before_action :render_unauthorized_if_no_current_user

  before_action :set_highlight, only: [:update, :destroy]

  def create
    inbound_binding, error = bind(params.require(:highlight), Api::V0::Bindings::NewHighlight)
    render(json: error, status: error.status_code) and return if error

    created_highlight = service_limits.with_create_protection do |user|
      inbound_binding.create_model!(user_id: user.id)
    end

    response_binding = Api::V0::Bindings::Highlight.create_from_model(created_highlight)
    render json: response_binding, status: :created
  end

  def index
    inbound_binding, error = bind(query_parameters, Api::V0::Bindings::GetHighlightsParameters)
    render(json: error, status: error.status_code) and return if error

    query_result = inbound_binding.query(user_id: current_user_uuid)

    response_binding = Api::V0::Bindings::Highlights.create_from_query_result(query_result)
    render json: response_binding, status: :ok
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

    updated_highlight = service_limits.with_update_protection do
      inbound_binding.update_model!(@highlight)
    end

    response_binding = Api::V0::Bindings::Highlight.create_from_model(updated_highlight)
    render json: response_binding, status: :ok
  end

  def destroy
    service_limits.with_delete_reincrement do
      @highlight.destroy!
    end

    head :ok
  end

  private

  def service_limits
    ServiceLimits.new(user_id: current_user_uuid)
  end

  def set_highlight
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
