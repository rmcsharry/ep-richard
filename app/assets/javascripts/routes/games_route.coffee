Easypeasy.GamesRoute = Ember.Route.extend(Easypeasy.ResetScroll, {
  model: ->
    return this.store.find('game', {
      parent: @modelFor('parent').get('id')
    })
})
