namespace :curator do
  desc <<-DESC.strip_heredoc
    Sets the curator for a given scope, curated highlights are available by querying the set
    "curated:openstax".

    eg: rake curator:set[scope_uuid,curator_uuid]
  DESC
  task :set, [:scope_id, :curator_id] => :environment do |task, args|
    CuratorScope.where(scope_id: args[:scope_id]).destroy_all
    CuratorScope.create(args.to_hash)
  end

  desc <<-DESC.strip_heredoc
    Clears the curator for a given scope

    eg: rake curator:clear[scope_uuid]
  DESC
  task :clear, [:scope_id] => :environment do |task, args|
    CuratorScope.where(scope_id: args[:scope_id]).destroy_all
  end
end
