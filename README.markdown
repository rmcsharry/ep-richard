# EasyPeasy app

## Services used

### Server

* Linode (Ubuntu 14LTS)

### Storing videos

* None (Amazon S3)

### Transactional email

* None (Postmark?)

## How to

### Access the rails console on production

    ssh `whoami`@85.159.211.37
    cd /home/easypeasy/app/
    sudo su easypeasy
    bundle exec rails console production
 
