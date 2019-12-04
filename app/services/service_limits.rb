# ServiceLimits
#
# This class is the guard check for the HighlightsController CRUD actions
class ServiceLimits
  MAX_HIGHLIGHTS_PER_SOURCE_PER_USER = 300
  MAX_HIGHLIGHTS_PER_USER            = 20_000
  MAX_ANNOTATION_CHARS_PER_USER      = 300_000
  MAX_CHARS_PER_ANNOTATION           = 1_000

  class ServiceLimitsError < StandardError; end

  class ExceededMaxHighlightsPerUser < ServiceLimitsError
    def message
      "Exceeded max highlights per user of #{MAX_HIGHLIGHTS_PER_USER}"
    end
  end

  class ExceededMaxHighlightsPerUserPerSource < ServiceLimitsError
    def message
      "Exceeded max highlights per user per source of #{MAX_HIGHLIGHTS_PER_SOURCE_PER_USER}"
    end
  end

  class ExceededMaxAnnotationCharsPerUser < ServiceLimitsError
    def message
      "Exceeded max annotation chars per user of #{MAX_ANNOTATION_CHARS_PER_USER}"
    end
  end

  class ExceededMaxAnnotationChars < ServiceLimitsError
    def message
      "Exceeded max chars per annotation of #{MAX_CHARS_PER_ANNOTATION}"
    end
  end

  def initialize(user_id:)
    @user_id = user_id
  end

  def with_create_protection
    ActiveRecord::Base.transaction do
      yield(user).tap do |model|
        raise ArgumentError, 'Block did not yield an active record model' unless model.is_a?(Highlight)
        raise ActiveRecord::RecordInvalid.new(model) if model.invalid?

        track_and_validate_max_highlights(model)
        track_and_validate_annotation_chars(model) if model.annotation.present?
      end
    end
  end

  def with_update_protection
    ActiveRecord::Base.transaction do
      yield.tap do |model|
        raise ArgumentError, 'Block did not yield an active record model' unless model.is_a?(Highlight)
        raise ActiveRecord::RecordInvalid.new(model) if model.invalid?

        prev_annotation_length = model.annotation_before_last_save.length
        reset_max_for_annotations(user: user, by: -prev_annotation_length) if prev_annotation_length.present?
        track_and_validate_annotation_chars(model) if model.annotation.present?
      end
    end
  end

  def with_delete_tracking
    ActiveRecord::Base.transaction do
      yield.tap do |model|
        raise ArgumentError, 'Block did not yield an active record model' unless model.is_a?(Highlight)

        track_counts_for_deleted_highlight(model)
      end
    end
  end

  private

  def user
    @user ||= User.find_or_create_by(id: @user_id)
  end

  def track_and_validate_max_highlights(new_highlight)
    if user.num_highlights < MAX_HIGHLIGHTS_PER_USER
      user.increment_num_highlights(by: 1)
    else
      raise ExceededMaxHighlightsPerUser
    end

    user_source = UserSource.find_or_create_by(user_id: user.id,
                                               source_type: new_highlight.source_type,
                                               source_id: new_highlight.source_id)
    if user_source.num_highlights < MAX_HIGHLIGHTS_PER_SOURCE_PER_USER
      user_source.increment_num_highlights(by: 1)
    else
      raise ExceededMaxHighlightsPerUserPerSource
    end
  end

  def track_and_validate_annotation_chars(new_highlight)
    return unless new_highlight.present?

    note_length = new_highlight.annotation.length

    if note_length > MAX_CHARS_PER_ANNOTATION
      raise ExceededMaxAnnotationChars
    end

    if user.num_annotation_characters + note_length < MAX_ANNOTATION_CHARS_PER_USER
      reset_max_for_annotations(user: user, by: note_length)
    else
      raise ExceededMaxAnnotationCharsPerUser
    end
  end

  def track_counts_for_deleted_highlight(highlight)
    user.increment_num_highlights(by: -1)
    reset_max_for_annotations(user: user, by: -highlight.annotation.length)

    user_source = UserSource.find_by(user_id: highlight.user.id, source_id: highlight.source_id)
    user_source.increment_num_highlights(by: -1)
  end

  def reset_max_for_annotations(user:, by:)
    user.increment_num_annotation_characters(by: by)
  end
end
