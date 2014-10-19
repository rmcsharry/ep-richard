Easypeasy.GamesController = Ember.ArrayController.extend
  needs: ['parent']
  parent: Ember.computed.alias("controllers.parent")

  sortProperties: ['created_at'],
  sortAscending: false
