Setting up for local development
================================

Prerequisites
-------------

* [rbenv][1] (install via Homebrew)

[1]: https://github.com/sstephenson/rbenv#homebrew-on-mac-os-x


Installing
----------

How to get EP-web setup locally.

#### 1. Create an ssh shortcut to the server

open the file:

    $ vim ~/.ssh/config

add the host:

    Host easypeasy
      HostName 85.159.211.37

#### 2. Install Ruby + Gems

Install the correct version of Ruby: `rbenv install`

Install bundler: `gem install bundler`

Install the gems: `bundle install`

#### 3. Create the local databases

    bundle exec foreman run rake db:create
    bundle exec foreman run rake db:migrate

#### 4. Import the production database

    ./import_backup.sh

#### 5. Get set up for deployment

See deploying-to-production.md.

#### 6. Set up PhantomJS for testing

Install via Homebrew. You might need to install a specific version of PhantomJS. Tested with Node v4.1.1 and PhantomJS v1.9.7.

    brew update && brew install phantomjs

Run the tests with 

    bundle exec foreman run rspec

#### 7. Start the server

    bundle exec foreman start

Then visit easypeasy.dev:3000
