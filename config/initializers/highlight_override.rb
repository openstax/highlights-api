# Monkey patch the generated Bindings for the swagger Highlight model

Api::V0::Bindings::NewHighlight.class_exec do
  def valid_location_strategies?
    location_strategies.present? &&
      location_strategies.none? { |item| item.nil? } &&
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
    end

    if location_strategies.any? { |item| item.nil? }
      invalid_properties.push('invalid strategy detected')
    end

    location_strategies&.each do |strategy|
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
