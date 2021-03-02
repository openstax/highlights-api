class HighlightsInfo
  GREATER_THAN_200 = 200
  GREATER_THAN_10 = 10
  GREATER_THAN_50 = 50

  def basic
    {
      env_name: env_name,
      accounts_env_name: accounts_env_name,
      ami_id: ami_id,
      git_sha: git_sha
    }
  end

  def extended
    basic.merge({
      postgres_version: postgres_version,
      data: data
    })
  end

  private

  DATA_FIELDS =
    [
      :total_highlights,
      :total_users,
      :total_notes,
      :avg_highlights_per_user,
      :median_highlights_per_user,
      :avg_note_length,
      :median_note_length,
      :max_note_length,
      :num_users_with_highlights,
      :num_users_gt_200_highlights_per_page,
      :num_users_gt_10_highlights,
      :num_users_gt_50_highlights,
      :num_users_with_notes,
      :max_num_highlights_any_user,
      :gen_started_at,
      :gen_ended_at
  ]

  def data
    info_data = Precalculated.info.first&.data&.with_indifferent_access

    Hash[DATA_FIELDS.collect { |field| [field, info_data ? info_data[field] : -1 ] }]
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
