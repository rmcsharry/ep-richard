Easypeasy.ParentRoute = Ember.Route.extend
  beforeModel: ->
    this.transitionTo('games')
