require 'recap/recipes/rails'

set :application, 'easypeasy'
set :repository, 'git@bitbucket.org:minified/easypeasy.git'

server '85.159.211.37', :app

set(:procfile) { "#{deploy_to}/Procfile.production" }

# TODO: hack.  Foreman now takes a --run option, which recap doesn't have a configuration option for
# https://github.com/tomafro/recap/blob/master/lib/recap/tasks/foreman.rb#L22
set(:foreman_export_command) { "./bin/foreman export #{foreman_export_format} #{foreman_tmp_location} --procfile #{procfile} --app #{application} --user #{application_user} --log #{deploy_to}/log --run #{deploy_to}" }

