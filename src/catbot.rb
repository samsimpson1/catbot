require "rufus-scheduler"
require_relative "timebot"

scheduler = Rufus::Scheduler.new

TimeBot.do_message

scheduler.cron '* * * * *' do
  TimeBot.do_message
end

scheduler.join