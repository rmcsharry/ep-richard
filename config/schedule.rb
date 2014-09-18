set :output, "#{path}/log/cron.log"

# every 1.day, :at => '10:00 am' do
#   command "cd #{path} && /usr/local/bin/bundle exec rails runner -e production lib/tasks/notify-parents.rb"
#   command "cd #{path} && /usr/local/bin/bundle exec rails runner -e production lib/tasks/notify-basil.rb"
# end

every 1.day do
  command "cd #{path} && /usr/local/bin/bundle exec rails runner -e production lib/tasks/notify-parents.rb"
end
