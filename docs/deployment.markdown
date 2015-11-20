Deployment
==========

EasyPeasy is deployed using Capistrano.


Deploy the app
--------------

    bundle exec cap deploy


Setting up on a new server
--------------------------

Will be worth figuring out the exact steps for this, but the rough idea is:

1. `bundle exec cap deploy:setup` clones and sets up the remote repo
2. After running the above, you need to run `bundle exec cap:deploy`


Setting up a new deploy user
----------------------------

1. Log on to the server
2. Add the user: `sudo adduser username`
3. Add the user to the sudoers group: `sudo adduser username sudo`
4. Log off
5. `brew install ssh-copy-id`
6. `ssh-copy-id username@easypeasy`
7. Test by doing `ssh username@easypeasy` then log off
8. `bundle exec cap bootstrap`
9. `bundle exec cap deploy`

Other things that might be relevant:

1. Add the user to the Bitbucket team/repo
2. Make sure the user's key is added to their Bitbucket account


Troubleshooting
---------------

Q: I moved the repo and now deploy doesn't work.

A: You need to change the repo in the Capfile, but also on the server in /home/easypeasy/.git. See [this](https://coderwall.com/p/4k1lja/fixing-capistrano-3-deployments-after-a-repository-change). If it really doesn't work, you could delete the folder on the server and run `bundle exec cap deploy:setup` again.
