# For more information see: http://emberjs.com/guides/routing/

Easypeasy.Router.map ()->
  @route 'index', path: '/'
  @resource 'parent', path: '/:parent_id', ->
    @resource 'games',  path: '/games'
    # TODO: Remove later. This next route is a temporary fix due to incorrect url (with an 's' as in 'games')
    # being sent in weekend SMS
    @resource 'game',   path: '/games/:game_id', ->
      @resource 'comments',   path: '/comments'
    @resource 'game',   path: '/game/:game_id', ->
      @resource 'comments',   path: '/comments'

Easypeasy.Router.reopen
  logTransition: ( ->
    $.post('/api/log', { location: this.get('url') })
  ).on('didTransition')
