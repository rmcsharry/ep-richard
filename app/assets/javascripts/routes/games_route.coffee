Easypeasy.GamesRoute = Ember.Route.extend
  model: ->
    return this.store.find('game')
