# EasyPeasy app

See `docs` folder for more documentation.

## To do

- Save comment
- Swap bootstrap

## Services used

### Server

* Linode (Ubuntu 14LTS)

### Storing videos

* Wistia

### Transactional email

* None (Postmark?)

## How to

### Access the rails console on production

    ssh `whoami`@85.159.211.37
    cd /home/easypeasy/app/
    sudo su easypeasy
    bundle exec rails console production
 
### Run a rails task locally

bundle exec foreman run rails runner lib/tasks/notify-parents.rb
