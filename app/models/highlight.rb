# OpenStax Highlights
#
# This is the main model for the Highlights API. This model represents the
# highlight or note used by the API
#
# See https://docs.google.com/document/d/1eUzJ6YDwK25K8gHllXljr5ELKE06tWjAh6hXIAYcqsw/edit#heading=h.v01zz2q3y1e7 for more information.
class Highlight < ApplicationRecord
  belongs_to :prev_highlight, class_name: 'Highlight', optional: true
  belongs_to :next_highlight, class_name: 'Highlight', optional: true

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
  validate :must_have_consistent_neighbors, on: :create

  enum source_type: [:openstax_page]

  scope :by_source_type, ->(source_type) { where(source_type: source_type) }
  scope :by_color, ->(color) { where(color: color) }
  scope :by_user, ->(user_id) { where(user_uuid: user_id) }
  scope :by_scope_id, ->(scope_id) { where(scope_id: scope_id) }
  scope :by_source_ids, ->(source_ids) { where(source_id: source_ids) }

  around_create :insert_new_highlight_between_neighbors
  before_destroy :reconnect_neighbors_around_destroyed_highlight

  def normalize_color
    self.color = color&.downcase
  end

  def normalize_ids
    if openstax_page?
      self.source_id = source_id&.downcase&.strip
      self.scope_id = scope_id&.downcase&.strip
    end
  end

  protected

  def all_from_scope_and_source
    Highlight.where(scope_id: scope_id).where(source_id: source_id)
  end

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

  def must_have_consistent_neighbors
    if prev_highlight_id.nil? && next_highlight_id.nil? && all_from_scope_and_source.any?
      errors.add(:base, 'Must specify previous or next highlight because there are other highlights ' \
                        'in this scope and source.')
    end

    if prev_highlight_id
      if prev_highlight.nil?
        errors.add(:prev_highlight_id, 'is unknown')
      else
        if prev_highlight.next_highlight_id != next_highlight_id
          errors.add(:base, 'The specified previous and next highlights are not adjacent')
        end
        if prev_highlight.source_id != source_id
          errors.add(:prev_highlight_id, 'does not reference a highlight in the same source')
        end
        if prev_highlight.scope_id != scope_id
          errors.add(:prev_highlight_id, 'does not live in the same scope')
        end
      end
    end

    if next_highlight_id
      if next_highlight.nil?
        errors.add(:next_highlight_id, 'is unknown')
      else
        if next_highlight.prev_highlight_id != prev_highlight_id
          errors.add(:base, 'The specified previous and next highlights are not adjacent')
        end
        if next_highlight.source_id != source_id
          errors.add(:next_highlight_id, 'does not reference a highlight in the same source')
        end
        if next_highlight.scope_id != scope_id
          errors.add(:next_highlight_id, 'does not live in the same scope')
        end
      end
    end

    errors.any?
  end

  def insert_new_highlight_between_neighbors
    self.order_in_source =
      if prev_highlight && next_highlight
        (prev_highlight.order_in_source + next_highlight.order_in_source)/2.0
      elsif prev_highlight
        prev_highlight.order_in_source + 1.0
      elsif next_highlight
        next_highlight.order_in_source - 1.0
      else
        0.0
      end

    yield # the create call, lets us have `id` set on next lines

    prev_highlight&.update_attributes(next_highlight_id: id)
    next_highlight&.update_attributes(prev_highlight_id: id)
  end

  def reconnect_neighbors_around_destroyed_highlight
    prev_highlight&.update_attributes(next_highlight_id: next_highlight_id)
    next_highlight&.update_attributes(prev_highlight_id: prev_highlight_id)
  end
end
