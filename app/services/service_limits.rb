class ServiceLimits
  MAX_HIGHLIGHTS_PER_SOURCE_PER_USER = 300
  MAX_HIGHLIGHTS_PER_USER = 20_000
  MAX_NOTE_CHARS_PER_USER = 300_000
  MAX_CHARS_PER_NOTE = 1_000
  MAX_HIGHLIGHTS_PER_GET = 300

  class ServiceLimitsError < StandardError; end
  class ExceededMaxHighlightsPerGet < ServiceLimitsError; end
  class ExceededMaxHighlightsPerUser < ServiceLimitsError; end
  class ExceededMaxHighlightsPerUserPerSource < ServiceLimitsError; end
  class ExceededMaxNoteCharsPerUser < ServiceLimitsError; end
  class ExceededMaxNoteChars < ServiceLimitsError; end

  def self.get_check(highlights)
    ActiveRecord::Base.transaction do
      validate_max_gets(request_highlights_count: highlights.count)

      yield highlights
    end
  end

  def self.create_check(user_uuid, inbound_binding)
    ActiveRecord::Base.transaction do
      user = User.find_or_create_by(id: user_uuid)

      validate_max_highlights(user: user, source_id: inbound_binding.source_id)
      validate_note_chars(user: user, note: inbound_binding.annotation)

      yield inbound_binding
    end
  end

  def self.update_check(user_uuid, inbound_binding)
    ActiveRecord::Base.transaction do
      user = User.find_or_create_by(id: user_uuid)

      validate_note_chars(user: user, note: inbound_binding.annotation)

      yield inbound_binding
    end
  end

  def self.delete_reset(user_uuid, highlight)
    ActiveRecord::Base.transaction do
      user = User.find_or_create_by(id: user_uuid)

      user.reset_max_counts(user: user, highlight: highlight)

      yield highlight
    end
  end

  private

  def self.validate_max_gets(request_highlights_count:)
    if request_highlights_count > MAX_HIGHLIGHTS_PER_GET
      raise ExceededMaxHighlightsPerGet
    end
  end

  def self.validate_max_highlights(user:, source_id:)
    if user.num_highlights < MAX_HIGHLIGHTS_PER_USER
      user.increment_num_highlights(by: 1)
    else
      raise ExceededMaxHighlightsPerUser
    end

    user_source = UserSource.find_or_create_by(users_id: user.id, source_id: source_id)
    if user_source.num_highlights >= MAX_HIGHLIGHTS_PER_SOURCE_PER_USER
      user_source.increment_num_highlights(by: 1)
    else
      raise ExceededMaxHighlightsPerUserPerSource
    end
  end

  def self.validate_note_chars(user:, note:)
    return unless note.present?

    note_length = note.length

    if note_length > MAX_CHARS_PER_NOTE
      raise ExceededMaxNoteChars
    end

    if user.num_annotation_characters + note_length < MAX_NOTE_CHARS_PER_USER
      user.increment_num_annotation_characters(by: note_length)
    else
      raise ExceededMaxNoteCharsPerUser
    end
  end

  def self.reset_max_counts(user:, highlight:)
    user.increment_num_highlights(by: -1)
    user.increment_num_annotation_characters(by: -highlight.annotation.length)

    user_source = UserSource.find_by(users_id: user.id, source_id: highlight.source_id)
    user_source.increment_num_highlights(by: -1)
  end
end
