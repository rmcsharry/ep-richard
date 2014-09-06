Easypeasy.GameController = Ember.ObjectController.extend
  iframeurl: ( ->
    "//fast.wistia.net/embed/iframe/#{@get('media_hashed_id')}?videoFoam=true&wmode=transparent"
  ).property()
