Easypeasy.GameController = Ember.Controller.extend
  needs: ['application', 'parent']
  application: Ember.computed.alias("controllers.application")
  parent: Ember.computed.alias('controllers.parent.model')

  commentsOpen: ( ->
    @get('application.currentRouteName') == 'comments'
  ).property('application.currentRouteName')
