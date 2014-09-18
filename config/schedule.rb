set :output, "#{path}/log/cron.log"

# This task ...

every 5.hours do
  command "cd #{path} && /usr/local/bin/bundle exec rails runner -e production lib/tasks/new-game-notification.rb"
end
