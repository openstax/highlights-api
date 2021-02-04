# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# Learn more: http://github.com/javan/whenever

require "tzinfo"

def local(time)
  TZInfo::Timezone.get('America/Denver').local_to_utc(Time.parse(time))
end

# Run every day at 6am central time
every :day, at: local('6:00 am') do
  runner 'InfoJob.perform_async'
end

