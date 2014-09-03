# For more information see: http://emberjs.com/guides/routing/

Easypeasy.Router.map ()->
  @resource 'parent', path: '/:parent_id', ->
    @resource 'games',  path: '/games/'
    @resource 'game',   path: '/game/:game_id'
