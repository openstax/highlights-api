# OpenStax Highlights
#
# This is the main model for the Highlights API. This model represents the
# highlight or note used by the API
#
# See https://docs.google.com/document/d/1eUzJ6YDwK25K8gHllXljr5ELKE06tWjAh6hXIAYcqsw/edit#heading=h.v01zz2q3y1e7 for more information.
class Highlight < ApplicationRecord
  VALID_COLOR = /#?[a-f0-9]{6}/
  VALID_UUID = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/

  validates_format_of :color, with: /\A#{VALID_COLOR}\z/
  validates_presence_of :user_uuid,
                        :source_type,
                        :source_id,
                        :anchor,
                        :highlighted_content,
                        :location_strategies

  validate :source_ids_uuid_for_openstax_page

  enum source_type: [:openstax_page]

  before_validation :normalize_color, :normalize_source_ids

  scope :by_source_type, ->(source_type) { where(source_type: source_type) }
  scope :by_color, ->(color) { where(color: color) }
  scope :by_user, ->(user_id) { where(user_uuid: user_id) }
  scope :by_order, ->(order_direction) {
    order_direction = order_direction.to_sym
    order(order_in_source: order_direction, source_order: order_direction)
  }
  scope :by_source_parent_ids, ->(source_parent_ids) do
    where('source_parent_ids && ?', postgres_style_array(source_parent_ids))
  end

  def normalize_color
    self.color = color&.downcase
  end

  def normalize_source_ids
    if openstax_page?
      self.source_id = source_id&.downcase&.strip
      source_parent_ids.map!(&:downcase).map!(&:strip)
    end
  end

  private

  def valid_uuid?(uuid)
    VALID_UUID.match?(uuid.to_s.downcase)
  end

  def source_ids_uuid_for_openstax_page
    return unless openstax_page?

    source_parent_ids.each do |source_parent_id|
      unless valid_uuid?(source_parent_id)
        errors.add(:source_parent_ids, 'source parent id of type openstax page must be a uuid')
      end
    end
    unless valid_uuid?(source_id)
      errors.add(:source_id, 'source id of type openstax page must be a uuid')
    end
  end

  def self.postgres_style_array(souce_parent_ids)
    "{#{souce_parent_ids.join(',')}}"
  end
end
