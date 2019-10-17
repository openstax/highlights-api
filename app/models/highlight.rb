# OpenStax Highlights
#
# This is the main model for the Highlights API. This model represents the
# highlight or note used by the API
#
# See https://docs.google.com/document/d/1eUzJ6YDwK25K8gHllXljr5ELKE06tWjAh6hXIAYcqsw/edit#heading=h.v01zz2q3y1e7 for more information.
class Highlight < ApplicationRecord
  validates_format_of :color, with: /\A#?(?:[A-F0-9]{3}){1,2}\z/i

  enum source_type: [:openstax_page]
end
