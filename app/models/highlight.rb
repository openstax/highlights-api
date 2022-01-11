# OpenStax Highlights
#
# This is the main model for the Highlights API. This model represents the
# highlight or note used by the API
#
# See https://docs.google.com/document/d/1eUzJ6YDwK25K8gHllXljr5ELKE06tWjAh6hXIAYcqsw/edit#heading=h.v01zz2q3y1e7 for more information.
class Highlight < ApplicationRecord
  belongs_to :prev_highlight, class_name: 'Highlight', optional: true
  belongs_to :next_highlight, class_name: 'Highlight', optional: true

  VALID_UUID = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/

  belongs_to :user

  before_validation :normalize_color, :normalize_ids
  before_validation :find_neighbors, on: :create

  validates_presence_of :user_id,
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
  scope :by_colors, ->(colors) { where(color: colors) }
  scope :by_user, ->(user_id) { where(user_id: user_id) }
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

  def page_content_fetchable?
    openstax_page? && source_metadata && source_metadata.keys.include?('bookVersion')
  end

  protected

  def all_mine_from_scope_and_source
    Highlight.where(user_id: user_id).where(scope_id: scope_id).where(source_id: source_id)
  end

  def fetch_page_anchors
    return unless page_content_fetchable?

    page_content = PageContent.new(
      book_uuid: scope_id,
      book_version: source_metadata['bookVersion'],
      page_uuid: source_id
    )

    page_content.fetch.anchors
  end

  def page_anchors
    @page_anchors ||= fetch_page_anchors
  end

  def anchor_paths
    paths = anchor_highlights.pluck(:id, :content_path).select {|h| h[1].present? }
    paths << [(id || 'new'), content_path] if content_path && !persisted?

    paths.sort_by(&:second)
  end

  def anchor_highlights
    all_mine_from_scope_and_source.where(anchor: anchor).order(:order_in_source)
  end

  def anchor_paths_self_index
    identifier = id || 'new'
    anchor_paths.index {|i| i[0] == identifier }
  end

  def find_prev_content_path_neighbor_id
    return nil unless anchor_paths_self_index
    anchor_paths_self_index == 0 ? nil : anchor_paths[anchor_paths_self_index - 1]&.at(0)
  end

  def find_next_content_path_neighbor_id
    return nil unless anchor_paths_self_index
    anchor_paths[anchor_paths_self_index + 1]&.at(0)
  end

  def has_content_path_neighbor?
    !!(find_prev_content_path_neighbor_id || find_next_content_path_neighbor_id)
  end

  def find_neighbors
    anchors = all_mine_from_scope_and_source.order(:order_in_source).map(&:anchor)
    return unless anchors.any?

    # If the highlight is inside an existing anchor, find the neighbors
    # using content_path, otherwise find it relative to all page anchors
    if anchors.include?(anchor)
      set_inside_anchor_neighbors
    elsif page_anchors && page_anchors.any? && page_anchors.find_index(anchor)
      set_outside_anchor_neighbors
    elsif !prev_highlight_id && !next_highlight_id
      # There are saved neighbors, but placement cannot be determined - put it at the end
      self.prev_highlight_id = all_mine_from_scope_and_source.order(:order_in_source).last&.id
      self.next_highlight_id = nil
    end
  end

  def set_inside_anchor_neighbors
    if content_path.present? && anchor_paths.many? && has_content_path_neighbor?
      self.prev_highlight_id = find_prev_content_path_neighbor_id
      self.next_highlight_id = find_next_content_path_neighbor_id

      if prev_highlight
        self.next_highlight_id = prev_highlight.next_highlight_id
      elsif next_highlight
        self.prev_highlight_id = next_highlight.prev_highlight_id
      end
    else
      # we don't have any other data to compare, use the highlight ids sent
      return if prev_highlight_id || next_highlight_id
      # can't find placement data, no highlight ids sent - put it at the end
      self.prev_highlight_id = anchor_highlights.last&.id
      self.next_highlight_id = nil
    end
  end

  def set_outside_anchor_neighbors
    saved_neighbors = all_mine_from_scope_and_source.order(:order_in_source)
    index = page_anchors.find_index(anchor)
    prev_anchors = page_anchors.slice(0, index)
    next_neighbor = saved_neighbors.find do |highlight|
      neighbor_index = page_anchors.find_index(highlight.anchor)
      neighbor_index && neighbor_index > index
    end

    self.prev_highlight_id = saved_neighbors.select {|h| prev_anchors.include?(h.anchor) }.last&.id
    self.next_highlight_id = prev_highlight ? prev_highlight&.next_highlight_id : next_neighbor&.id
  end

  def valid_uuid?(uuid)
    VALID_UUID.match?(uuid.to_s.downcase)
  end

  def validate_uuid(field)
    unless VALID_UUID.match?(send(field).to_s.downcase)
      errors.add(field, "must be a UUID for source_type #{source_type}")
    end
  end

  def must_have_source_type_specific_ids
    if openstax_page?
      validate_uuid(:scope_id)
      validate_uuid(:source_id)
    end
  end

  def must_have_consistent_neighbors
    neighbors_must_only_be_blank_when_no_other_highlights_in_scope_and_source
    neighbors_must_be_known
    neighbors_must_share_same_source_as_self
    neighbors_must_share_same_scope_as_self
    neighbors_must_point_to_each_other
  end

  def neighbors_must_only_be_blank_when_no_other_highlights_in_scope_and_source
    if prev_highlight_id.nil? && next_highlight_id.nil? && all_mine_from_scope_and_source.any?
      errors.add(:base, 'Must specify previous or next highlight because there are other highlights ' \
                        'in this scope and source.')
    end
  end

  def neighbors_must_be_known
    errors.add(:next_highlight_id, 'is unknown') if next_highlight_id && next_highlight.nil?
    errors.add(:prev_highlight_id, 'is unknown') if prev_highlight_id && prev_highlight.nil?
  end

  def neighbors_must_share_same_source_as_self
    message = 'does not reference a highlight in the same source'
    errors.add(:next_highlight_id, message) if next_highlight && next_highlight.source_id != source_id
    errors.add(:prev_highlight_id, message) if prev_highlight && prev_highlight.source_id != source_id
  end

  def neighbors_must_share_same_scope_as_self
    message = 'does not live in the same scope'
    errors.add(:next_highlight_id, message) if next_highlight && next_highlight.scope_id != scope_id
    errors.add(:prev_highlight_id, message) if prev_highlight && prev_highlight.scope_id != scope_id
  end

  def neighbors_must_point_to_each_other
    if (prev_highlight && prev_highlight.next_highlight_id != next_highlight_id) ||
       (next_highlight && next_highlight.prev_highlight_id != prev_highlight_id)
      errors.add(:base, 'The specified previous and next highlights are not adjacent')
    end
  end

  def insert_new_highlight_between_neighbors
    set_order_in_source_between_neighbors

    yield # the create call

    point_neighbors_to_self # has to be after create call so that the `id` of self is available
  end

  def set_order_in_source_between_neighbors
    self.order_in_source =
      if prev_highlight && next_highlight
        # The actual "between" case, pick a value right in the middle
        (prev_highlight.order_in_source + next_highlight.order_in_source)/2.0
      elsif prev_highlight
        # The highlight is inserted at the end, so pick an arbitrary order after prev's
        prev_highlight.order_in_source + 1.0
      elsif next_highlight
        # The highlight is inserted at the start, so pick an arbitrary order before next's
        next_highlight.order_in_source - 1.0
      else
        # No highlights yet in this source, so start with an arbitrary order value of 0
        0.0
      end
  end

  def point_neighbors_to_self
    prev_highlight&.update_attributes(next_highlight_id: id)
    next_highlight&.update_attributes(prev_highlight_id: id)
  end

  def reconnect_neighbors_around_destroyed_highlight
    prev_highlight&.update_attributes(next_highlight_id: next_highlight_id)
    next_highlight&.update_attributes(prev_highlight_id: prev_highlight_id)
  end
end
