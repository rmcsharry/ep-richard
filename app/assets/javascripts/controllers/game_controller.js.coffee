Easypeasy.GameController = Ember.Controller.extend
  needs: ['application']
  application: Ember.computed.alias("controllers.application")

  commentsOpen: ( ->
    @get('application.currentRouteName') == 'comments'
  ).property('application.currentRouteName')
