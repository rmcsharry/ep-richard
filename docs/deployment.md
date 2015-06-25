Deployment
==========

EasyPeasy is deployed using Capistrano.

Setting up on a new server
--------------------------

Will be worth figuring out the exact steps for this, but the rough idea is:

1. `bundle exec cap deploy:setup` clones and sets up the remote repo
2. After running the above, you need to run `bundle exec cap:deploy`

Setting up a new deploy user
----------------------------

Write notes here next time you set someone up.

I think the steps will include:

1. Get set up on the server as a user
2. ssh-copy-id to the server
3. Add the user to the Bitbucket team/repo
4. Make sure the user's key is added to their Bitbucket account
5. `bundle exec cap bootstrap`
6. `bundle exec cap deploy`

Deploy
------

    bundle exec cap deploy

Troubleshooting
---------------

Q: I moved the repo and now deploy doesn't work.

A: You need to change the repo in the Capfile, but also on the server in /home/easypeasy/.git. See [this](https://coderwall.com/p/4k1lja/fixing-capistrano-3-deployments-after-a-repository-change). If it really doesn't work, you could delete the folder on the server and run `bundle exec cap deploy:setup` again.
