class HighlightFilter
  def initialize(user_id:, params:)
    @params = params
    @highlights = Highlight.by_user(user_id)
  end

  def call
    filtered_params.each do |key, value|
      @highlights = @highlights.public_send("by_#{key}", value) if value.present?
    end
    @highlights
  end

  private

  def filtered_params
    @params.slice(:source_type, :source_parent_ids, :color)
  end
end
