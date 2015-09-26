# EasyPeasy app

See `docs` folder for more documentation.

## How to

### Start the server

    bundle exec foreman start

### Run the tests

    bundle exec foreman run rspec

### Access the rails console on production

    ssh `whoami`@85.159.211.37
    cd /home/easypeasy/app/
    sudo su easypeasy
    bundle exec rails console production
 
### Import the production database

    ./import_backup.sh

### Run a rails task locally

Use `rails runner`, for example:

    bundle exec foreman run rails runner lib/tasks/notify-parents.rb
