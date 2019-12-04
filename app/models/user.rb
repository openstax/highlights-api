# frozen_string_literal: true

class User < ApplicationRecord
  has_many :highlights, dependent: :destroy
  has_many :user_sources, dependent: :destroy

  before_validation :check_for_negative_limits

  def increment_num_highlights(by: 1)
    update(num_highlights: num_highlights + by)
  end

  def increment_num_annotation_characters(by:)
    update(num_annotation_characters: num_annotation_characters + by)
  end

  private

  def check_for_negative_limits
    if self.num_highlights.negative?
      Rails.logger.error("Resetting num_highlights 0 for user #{inspect}")
      self.num_highlights = 0
    end

    if self.num_annotation_characters.negative?
      Rails.logger.error("Resetting num_annotation_characters to 0 for user #{inspect}")
      self.num_annotation_characters = 0
    end
  end
end
