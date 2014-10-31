Easypeasy.GamesController = Ember.ArrayController.extend
  needs: ['parent']
  parent: Ember.computed.alias('controllers.parent')

  sortProperties: ['in_default_set:asc', 'position:desc']
  sortedGames: Ember.computed.sort('model', 'sortProperties')
