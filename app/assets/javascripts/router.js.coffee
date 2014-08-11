# For more information see: http://emberjs.com/guides/routing/

Easypeasy.Router.map ()->
  @resource 'games', path: '/'
  @resource 'game', path: '/games/:game_id'
