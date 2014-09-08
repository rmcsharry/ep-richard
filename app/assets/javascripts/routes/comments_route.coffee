Easypeasy.CommentsRoute = Ember.Route.extend
  model: ->
    return this.store.find('comment', {
      game:   @modelFor('game').get('id')
      parent: @modelFor('parent').get('slug')
    }).then( (models) -> models.toArray() )
