class UserSource < ApplicationRecord
  belongs_to :user

  scope :by_source_id, ->(source_id) { where(source_id: source_id) }

  def increment_num_highlights(by: 1)
    update(num_highlights: num_highlights + by)
  end
end
