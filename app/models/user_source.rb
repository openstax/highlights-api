class UserSource < ApplicationRecord
  belongs_to :user

  before_validation :check_for_negative_limits

  scope :by_source_id, ->(source_id) { where(source_id: source_id) }

  def increment_num_highlights(by: 1)
    update(num_highlights: num_highlights + by)
  end

  private

  def check_for_negative_limits
    if self.num_highlights.negative?
      Rails.logger.error("Resetting num_highlights to 0 for user_source #{inspect}")
      self.num_highlights = 0
    end
  end
end
