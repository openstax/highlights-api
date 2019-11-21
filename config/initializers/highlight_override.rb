# frozen_string_literal: true

# Monkey patch the generated Bindings for the swagger Highlight model

Api::V0::Bindings::NewHighlight.class_exec do
  def valid_location_strategies?
    location_strategies.present? &&
      location_strategies.none?(&:nil?) &&
      location_strategies.all?(&:valid?)
  end

  def location_strategies=(array)
    @location_strategies = array.map do |item|
      case item[:type]
      when 'TextPositionSelector'
        Api::V0::Bindings::TextPositionSelector.new(item)
      when 'XpathRangeSelector'
        Api::V0::Bindings::XpathRangeSelector.new(item)
      end
    end
  end

  alias_method :old_valid?, :valid?
  def valid?
    old_valid? && valid_location_strategies?
  end

  alias_method :old_list_invalid_properties, :list_invalid_properties
  def list_invalid_properties
    invalid_properties = old_list_invalid_properties

    if location_strategies.blank?
      invalid_properties.push('invalid value for "location_strategies", location_strategies cannot be empty.')
      return invalid_properties
    end

    invalid_properties.push('Empty or invalid strategy detected') if location_strategies.any?(&:nil?)

    location_strategies.each do |strategy|
      next if strategy.nil?
      strategy.list_invalid_properties.each do |strategy_invalid_property|
        invalid_properties.push("invalid value for location strategy #{strategy.type}: #{strategy_invalid_property}")
      end
    end

    invalid_properties
  end
end

Api::V0::Bindings::Highlight.class_exec do
  def self.create_from_model(model)
    new(model.attributes)
  end
end

Api::V0::Bindings::NewHighlight.class_exec do
  def create_model!(user_uuid:)
    Highlight.create!(to_hash.merge(user_uuid: user_uuid))
  end
end

Api::V0::Bindings::Highlights.class_exec do
  def self.create_from_query_result(query_result)
    highlights = query_result[:items]

    highlights_bindings = highlights.map do |highlight|
      Api::V0::Bindings::Highlight.create_from_model(highlight)
    end

    new(
      meta: query_result.slice(
        :page,
        :per_page,
        :total_count
      ).merge(
        count: highlights.size
      ),
      data: highlights_bindings
    )
  end
end

Api::V0::Bindings::GetHighlights.class_exec do
  def query(user_uuid:)
    highlights = ::Highlight.by_user(user_uuid)

    # The submitted GetHighlight properties create automatic chaining via
    # the by_X scopes on the Highlight model.
    to_hash.except(:page, :per_page).each do |key, value|
      highlights = highlights.public_send("by_#{key}", value) if value.present?
    end

    highlights = highlights.to_a

    if source_ids.present?
      # Sort the highlights in Ruby, not Postgres
      source_id_order = source_ids.each_with_object({}).with_index do |(source_id, hash), index|
        hash[source_id] = index
      end

      highlights.sort_by!{ |highlight| [source_id_order[highlight.source_id], highlight.order_in_source] }
    else
      # Have to sort by something for pagination to be sensible, choose created_at
      highlights.sort_by!(&:created_at)
    end

    local_page = page || Api::V0::Swagger::Models::Highlight::DEFAULT_HIGHLIGHTS_PAGE
    local_per_page = per_page || Api::V0::Swagger::Models::Highlight::DEFAULT_HIGHLIGHTS_PER_PAGE

    first_index_in_page = (local_page - 1) * local_per_page
    last_index_in_page = first_index_in_page + local_per_page - 1

    {
      page: local_page,
      per_page: local_per_page,
      total_count: highlights.size,
      items: highlights[first_index_in_page..last_index_in_page]
    }
  end
end

Api::V0::Bindings::UpdateHighlight.class_exec do
  def update_model!(model)
    model.color = color if color.present?
    model.annotation = annotation if annotation.present?
    model.tap(&:save!)
  end
end
