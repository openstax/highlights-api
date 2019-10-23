# OpenStax Highlights
#
# This is the main model for the Highlights API. This model represents the
# highlight or note used by the API
#
# See https://docs.google.com/document/d/1eUzJ6YDwK25K8gHllXljr5ELKE06tWjAh6hXIAYcqsw/edit#heading=h.v01zz2q3y1e7 for more information.
class Highlight < ApplicationRecord
  validates_format_of :color, with: /\A#?(?:[a-f0-9]{3}){1,2}\z/
  validates_presence_of :user_uuid,
                        :source_type,
                        :anchor,
                        :highlighted_content,
                        :location_strategies

  enum source_type: [:openstax_page]

  before_validation :normalize_color, :normalize_source_ids

  def normalize_color
    self.color = color&.downcase
  end

  def normalize_source_ids
    if openstax_page?
      self.source_id = source_id&.downcase
      source_parent_ids.map!(&:downcase)
    end
  end
end
