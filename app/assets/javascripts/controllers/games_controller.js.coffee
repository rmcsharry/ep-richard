Easypeasy.GamesController = Ember.Controller.extend
  needs: ['parent']
  parent: Ember.computed.alias('controllers.parent.model')
  
  sortProperties: ['in_default_set:asc', 'position:asc']
  sortedGames: Ember.computed.sort('model', 'sortProperties')

  isScreenOne: true
  isScreenTwo: false
  isScreenThree: false
  startNotClicked: true
  
  
  actions:
    screenOne: ->
	    @toggleProperty 'isScreenOne'
	    @toggleProperty 'isScreenTwo'
	    return false
    screenTwo: ->  
      @toggleProperty 'isScreenTwo'
      @toggleProperty 'isScreenThree'
      return false
    screenThree: ->  
      @toggleProperty 'isScreenThree'
      @toggleProperty 'isScreenOne'
      return false
    getStarted: ->
      @toggleProperty 'startNotClicked'
      return false
      
