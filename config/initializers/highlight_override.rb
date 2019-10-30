# Monkey patch the generated Bindings for the swagger Highlight model
require_relative '../../app/bindings/api/v0/bindings/new_highlight'

module Api::V0::Bindings
  class NewHighlight
    def valid_location_strategies?
      location_strategies = to_hash[:location_strategies]
      location_strategies.all? do |location_strategy|
        strategy = JSON.parse(location_strategy)
        case strategy['type']
        when 'TextPositionSelector'
          keys_matcher(%w(start end), strategy.keys)
        when 'XpathRangeSelector'
          keys_matcher(%w(endContainer endOffset startContainer startOffset),
                       strategy.keys)
        else
          false
        end
      end
    end

    def keys_matcher(desired_keys, strategy_keys)
      (desired_keys & strategy_keys).size == desired_keys.size
    end

    alias_method :old_valid?, :valid?
    def valid?
      old_valid? && valid_location_strategies?
    end
  end
end
