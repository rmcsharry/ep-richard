require 'recap/recipes/rails'

set :whenever_command, "bundle exec whenever"
require "whenever/capistrano"

set :application, 'easypeasy'
set :repository, 'git@bitbucket.org:easypeasy/easypeasy.git'

server '85.159.211.37', :app

set(:procfile) { "#{deploy_to}/Procfile.production" }

# TODO: hack.  Foreman now takes a --run option, which recap doesn't have a configuration option for
# https://github.com/tomafro/recap/blob/master/lib/recap/tasks/foreman.rb#L22
set(:foreman_export_command) { "./bin/foreman export #{foreman_export_format} #{foreman_tmp_location} --procfile #{procfile} --app #{application} --user #{application_user} --log #{deploy_to}/log --run #{deploy_to}" }

set :whenever_command, "bundle exec whenever"
set(:whenever_identifier)   { application }
set(:whenever_update_flags) { "--update-crontab #{whenever_identifier} -u #{application_user}" }
set(:whenever_clear_flags)  { "--clear-crontab #{whenever_identifier} -u #{application_user}" }

before "deploy:update_code", "whenever:clear_crontab"
after "deploy:tag", "whenever:update_crontab"
after "deploy:rollback", "whenever:update_crontab"

namespace :whenever do
  desc "Update application's crontab entries using Whenever"
  task :update_crontab, :roles => :app do
    as_app "#{whenever_command} #{whenever_update_flags}"
  end

  desc "Clear application's crontab entries using Whenever"
  task :clear_crontab, :roles => :app do
    as_app "#{whenever_command} #{whenever_clear_flags}"
  end
end
