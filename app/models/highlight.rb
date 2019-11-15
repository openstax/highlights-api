# OpenStax Highlights
#
# This is the main model for the Highlights API. This model represents the
# highlight or note used by the API
#
# See https://docs.google.com/document/d/1eUzJ6YDwK25K8gHllXljr5ELKE06tWjAh6hXIAYcqsw/edit#heading=h.v01zz2q3y1e7 for more information.
class Highlight < ApplicationRecord
  VALID_COLOR = /#?[a-f0-9]{6}/
  VALID_UUID = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/

  before_validation :normalize_color, :normalize_ids

  validates_format_of :color, with: /\A#{VALID_COLOR}\z/
  validates_presence_of :user_uuid,
                        :source_type,
                        :source_id,
                        :anchor,
                        :highlighted_content,
                        :location_strategies

  validate :must_have_source_type_specific_ids

  enum source_type: [:openstax_page]

  scope :by_source_type, ->(source_type) { where(source_type: source_type) }
  scope :by_color, ->(color) { where(color: color) }
  scope :by_user, ->(user_id) { where(user_uuid: user_id) }
  scope :by_scope_id, ->(scope_id) { where(scope_id: scope_id) }

  def normalize_color
    self.color = color&.downcase
  end

  def normalize_ids
    if openstax_page?
      self.source_id = source_id&.downcase&.strip
      self.scope_id = scope_id&.downcase&.strip
    end
  end

  private

  def valid_uuid?(uuid)
    VALID_UUID.match?(uuid.to_s.downcase)
  end

  def validate_uuid(field, is_source_type_specific:)
    unless VALID_UUID.match?(send(field).to_s.downcase)
      errors.add(field, "must be a UUID#{' for source_type ' + source_type if is_source_type_specific}")
    end
  end

  def must_have_source_type_specific_ids
    if openstax_page?
      validate_uuid(:scope_id, is_source_type_specific: true)
      validate_uuid(:source_id, is_source_type_specific: true)
    end
  end
end
