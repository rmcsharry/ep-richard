Easypeasy.GameController = Ember.ObjectController.extend
  videoEmbed: ( ->
    "<iframe src='//fast.wistia.net/embed/iframe/#{@get('media_hashed_id')}?videoFoam=true&wmode=transparent' allowtransparency='true' frameborder='0' scrolling='no' class='wistia_embed videoIframe' name='wistia_embed' allowfullscreen mozallowfullscreen webkitallowfullscreen oallowfullscreen msallowfullscreen width='300' height='169'></iframe><script src='//fast.wistia.net/assets/external/iframe-api-v1.js'></script>"
  ).property()
