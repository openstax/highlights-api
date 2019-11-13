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

    invalid_properties.push('invalid strategy detected') if location_strategies.any?(&:nil?)

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
  def self.create_from_models(highlights, pagination)
    highlights = highlights.to_a unless highlights.is_a? Array
    meta = pagination.merge(total_count: highlights.count)
    attribs = { meta: meta, data: highlights }
    highlights_response = new(attribs)
  end
end

Api::V0::Bindings::GetHighlights.class_exec do
  PAGING_DEFAULTS = {
    per_page: 15,
    page: 1
  }.freeze

  FILTER_DEFAULTS = {
    order: 'asc'
  }.freeze

  def query(user_uuid:)
    highlights = ::Highlight.by_user(user_uuid)

    # The submitted GetHighlight properties create automatic chaining via
    # the by_X scopes on the Highlight model.
    pagination = to_hash.dup
    filter_by = pagination.slice!(:page, :per_page)
    filter_by = FILTER_DEFAULTS.merge(filter_by)
    filter_by.each do |key, value|
      highlights = highlights.public_send("by_#{key}", value) if value.present?
    end
    pagination = PAGING_DEFAULTS.merge(pagination)

    [highlights.paginate(pagination), pagination]
  end
end

