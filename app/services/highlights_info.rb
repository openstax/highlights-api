class HighlightsInfo
  def call
    results
  end

  private

  def results
    {
      postgres_version: postgres_version,
      env_name: env_name,
      accounts_env_name: accounts_env_name,
      ami_id: ami_id,
      data: {
        total_highlights: total_highlights,
        total_users: total_users,
        avg_highlights_per_user: avg_highlights_per_user,
        num_users_with_highlights: num_users_with_highlights,
        max_num_highlights_any_user: max_num_highlights_any_user,
        total_notes: total_notes,
        avg_note_length: avg_note_length
      }
    }
  end

  def total_highlights
    Highlight.count
  end

  def total_users
    User.count
  end

  def avg_highlights_per_user
    query = <<-SQL
       SELECT
         AVG(highlights_count)
         FROM
          ( SELECT
              COUNT(*) AS highlights_count
            FROM highlights
            GROUP BY user_id) temp_table
    SQL

    ActiveRecord::Base.connection.select_value(query).to_i
  end

  def num_users_with_highlights
    Highlight.distinct.pluck(:user_id).count
  end

  def max_num_highlights_any_user
    query = <<-SQL
       SELECT
         MAX(highlights_count)
         FROM
          ( SELECT
              COUNT(*) AS highlights_count
            FROM highlights
            GROUP BY user_id) temp_table
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
      WHERE annotation IS NOT NULL
    SQL

    ActiveRecord::Base.connection.select_value(query).to_i
  end

  def postgres_version
    ActiveRecord::Base.connection.select_value('SELECT version()')
  end

  def env_name
    ENV['ENV_NAME'] || 'Not set'
  end

  def accounts_env_name
    ENV['ACCOUNTS_ENV_NAME'] || 'Not set'
  end

  def ami_id
    ENV['AMI_ID'] || 'Not set'
  end
end
