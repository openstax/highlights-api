desc <<-DESC.strip_heredoc
  Clear out all service limits, resetting to 0
DESC
task clear_service_limits: :environment do
  user_updated_count = User.update_all(num_annotation_characters: 0, num_highlights: 0)
  user_source_updated_count = UserSource.update_all(num_highlights: 0)

  puts "Reset #{user_updated_count} users records to 0."
  puts "Reset #{user_source_updated_count} user_sources records to 0."
end
