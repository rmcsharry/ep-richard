# For more information see: http://emberjs.com/guides/routing/

Easypeasy.Router.map ()->
  @route 'index', path: '/'
  @resource 'parent', path: '/:parent_id', ->
    @resource 'games',  path: '/games'
    @resource 'game',   path: '/game/:game_id', ->
      @resource 'comments',   path: '/comments'

Easypeasy.Router.reopen
  notifyGoogleAnalytics: ( ->
    ga 'send', 'pageview',
      'page':  location.hash,
      'title': this.get('url'),
  ).on('didTransition')
