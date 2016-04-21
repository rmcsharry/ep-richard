set :output, "#{path}/log/cron.log"

every 1.day, :at => '3:00 pm' do
  command "cd #{path} && /usr/local/bin/bundle exec rails runner -e production lib/tasks/notify-parents.rb"
  command "cd #{path} && /usr/local/bin/bundle exec rails runner -e production lib/tasks/notify-parents-extra.rb"
  command "cd #{path} && /usr/local/bin/bundle exec rails runner -e production lib/tasks/notify-basil.rb"
end

# This is a hack until we implement a queue
every 1.day, :at => '4:30 pm' do
  command "cd #{path} && /usr/local/bin/bundle exec rails runner -e production lib/tasks/notify-parents.rb"
  command "cd #{path} && /usr/local/bin/bundle exec rails runner -e production lib/tasks/notify-basil.rb"
end

every 1.day, :at => '8:30 am' do
  command "cd #{path} && /usr/local/bin/bundle exec rails runner -e production lib/tasks/email-pod-admins.rb"
end

every :sunday, :at => '11:00 am' do
  command "cd #{path} && /usr/local/bin/bundle exec rails runner -e production lib/tasks/weekend_sms_to_parents.rb"
end
