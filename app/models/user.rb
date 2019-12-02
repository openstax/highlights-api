class User < ApplicationRecord
  has_many :highlights, dependent: :destroy
  has_many :user_sources, dependent: :destroy

  def increment_num_highlights(by: 1)
    update(num_highlights: [num_highlights + by, 0].max)
  end

  def increment_num_annotation_characters(by: 1)
    update(num_annotation_characters: [num_annotation_characters + by, 0].max)
  end
end
