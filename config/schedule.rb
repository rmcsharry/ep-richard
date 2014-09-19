set :output, "#{path}/log/cron.log"

every 1.day, :at => '3:00 pm' do
  command "cd #{path} && /usr/local/bin/bundle exec rails runner -e production lib/tasks/notify-parents.rb"
  command "cd #{path} && /usr/local/bin/bundle exec rails runner -e production lib/tasks/notify-basil.rb"
end
