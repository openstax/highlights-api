class InfoStore
  GREATER_THAN_200 = 200
  GREATER_THAN_10 = 10
  GREATER_THAN_50 = 50

  def call
    started_at = DateTime.now
    local_data = data
    local_data[:gen_started_at] = started_at
    local_data[:gen_ended_at] = DateTime.now

    Precalculated.info.first_or_initialize.tap do |precalc|
      precalc.data = local_data
      precalc.save!
    end
  end

  private

  def data
    {
      total_highlights: total_highlights,
      total_users: total_users,
      total_notes: total_notes,
      avg_highlights_per_user: avg_highlights_per_user,
      median_highlights_per_user: median_highlights_per_user,
      avg_note_length: avg_note_length,
      median_note_length: median_note_length,
      max_note_length: max_note_length,
      num_users_with_highlights: num_users_with_highlights,
      num_users_gt_200_highlights_per_page: num_users_gt_200_highlights_per_page,
      num_users_gt_10_highlights: num_users_gt_10_highlights,
      num_users_gt_50_highlights: num_users_gt_50_highlights,
      num_users_with_notes: num_users_with_notes,
      max_num_highlights_any_user: max_num_highlights_any_user
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

  def median_highlights_per_user
    query = <<-SQL
        SELECT
          percentile_disc(0.5) 
          WITHIN group (order by highlights_count)         
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

  def num_users_with_notes
    Highlight.where.not(annotation: nil).distinct.pluck(:user_id).count
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

  def num_users_gt_200_highlights_per_page
    query = <<-SQL
      SELECT
        count(*)
      FROM
        ( SELECT
            COUNT(*)
          FROM highlights
          GROUP BY user_id, source_id
            HAVING COUNT(*) > #{GREATER_THAN_200}) temp_table
    SQL

    ActiveRecord::Base.connection.select_value(query)
  end

  def num_users_gt_10_highlights
    num_users_gt_highlights(than: GREATER_THAN_10)
  end

  def num_users_gt_50_highlights
    num_users_gt_highlights(than: GREATER_THAN_50)
  end

  def num_users_gt_highlights(than:)
    query = <<-SQL
      SELECT
        count(*)
      FROM
        ( SELECT
            COUNT(*)
          FROM highlights
          GROUP BY user_id 
            HAVING COUNT(*) > #{than}) temp_table
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

  def median_note_length
    query = <<-SQL
      SELECT
        percentile_disc(0.5)
        WITHIN group (order by note_size)
        FROM
          (SELECT
             pg_column_size(annotation) 
             FROM highlights
             WHERE annotation IS NOT NULL) as note_size
    SQL

    ActiveRecord::Base.connection.select_value(query)&.gsub(/[()]/, "").to_i
  end

  def max_note_length
    query = <<-SQL
      SELECT
       MAX(pg_column_size(annotation))
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

  def git_sha
    `git show --pretty=%H -q`&.chomp || 'Not set'
  end
end
