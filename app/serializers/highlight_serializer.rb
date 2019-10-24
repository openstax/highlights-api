class HighlightSerializer < ActiveModel::Serializer
  attributes :id, :source_type, :source_id, :location_strategies
end
