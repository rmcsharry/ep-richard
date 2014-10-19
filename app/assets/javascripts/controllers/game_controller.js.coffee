Easypeasy.GameController = Ember.ObjectController.extend
  needs: ['application']
  application:   Ember.computed.alias("controllers.application")

  iframeurl: ( ->
    "//fast.wistia.net/embed/iframe/#{@get('media_hashed_id')}?videoFoam=true&wmode=transparent"
  ).property('media_hashed_id')

  commentsOpen: ( ->
    @get('application.currentRouteName') == 'comments'
  ).property('application.currentRouteName')
