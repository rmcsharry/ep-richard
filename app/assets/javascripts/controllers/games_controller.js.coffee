Easypeasy.GamesController = Ember.Controller.extend
  needs: ['parent']
  parent: Ember.computed.alias('controllers.parent.model')

  sortProperties: ['in_default_set:asc', 'position:asc']
  sortedGames: Ember.computed.sort('model', 'sortProperties')
