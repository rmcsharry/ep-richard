Easypeasy.GameController = Ember.Controller.extend
  needs: ['application']
  application: Ember.computed.alias("controllers.application")

  iframeurl: ( ->
    "//fast.wistia.net/embed/iframe/#{@get('model.media_hashed_id')}?videoFoam=true&wmode=transparent"
  ).property('model.media_hashed_id')

  commentsOpen: ( ->
    @get('application.currentRouteName') == 'comments'
  ).property('application.currentRouteName')
