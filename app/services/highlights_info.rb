class HighlightsInfo
  def call
    results
  end

  private

  def results
    {
      postgres_version: postgres_version,
      data: {
        total_highlights: total_highlights,
        avg_highlights_per_user: avg_highlights_per_user,
        max_num_highlights_any_user: max_num_highlights_any_user,
        total_notes: total_notes,
        avg_note_length: avg_note_length
      }
    }
  end

  def total_highlights
    Highlight.count
  end

  def avg_highlights_per_user
    query = <<-SQL
       SELECT
         AVG(highlights_count)
         FROM
          ( SELECT
              COUNT(*) AS highlights_count
            FROM highlights
            GROUP BY user_uuid) temp_table
    SQL

    ActiveRecord::Base.connection.select_value(query)
  end

  def max_num_highlights_any_user
    query = <<-SQL
       SELECT
         MAX(highlights_count)
         FROM
          ( SELECT
              COUNT(*) AS highlights_count
            FROM highlights
            GROUP BY user_uuid) temp_table
    SQL

    ActiveRecord::Base.connection.select_value(query)
  end

  def total_notes
    Highlight.where.not(annotation: nil).count
  end

  def avg_note_length
    query = <<-SQL
      SELECT
       AVG(pg_column_size(annotation))
      FROM highlights
    SQL

    ActiveRecord::Base.connection.select_value(query)
  end

  def postgres_version
    ActiveRecord::Base.connection.select_value('SELECT version()')
  end
end
