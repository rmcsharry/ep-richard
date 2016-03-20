Easypeasy.GamesController = Ember.Controller.extend
  needs: ['parent']
  parent: Ember.computed.alias('controllers.parent.model')
  
  sortProperties: ['in_default_set:asc', 'position:asc']
  sortedGames: Ember.computed.sort('model', 'sortProperties')

  isScreenOne: true
  isScreenTwo: false
  isScreenThree: false
  isStartNotClicked: true 
  
  actions:
    rightFromOne: ->
      @toggleProperty 'isScreenOne'
      @toggleProperty 'isScreenTwo'
      return false
    rightFromTwo: ->  
      @toggleProperty 'isScreenTwo'
      @toggleProperty 'isScreenThree'
      return false
    leftFromTwo: ->  
      @toggleProperty 'isScreenTwo'
      @toggleProperty 'isScreenOne'
      return false
    leftFromThree: ->  
      @toggleProperty 'isScreenTwo'
      @toggleProperty 'isScreenThree'
      return false           
    startClicked: ->
      @toggleProperty 'isStartNotClicked'
      return false
