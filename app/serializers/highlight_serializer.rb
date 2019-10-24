class HighlightSerializer < ActiveModel::Serializer
  attributes :id, :source_type, :user_uuid, :source_id, :location_strategies
end
