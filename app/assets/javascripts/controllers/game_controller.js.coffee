Easypeasy.GameController = Ember.ObjectController.extend
  videoEmbed: ( ->
    "<iframe src='//fast.wistia.net/embed/iframe/#{@get('media_hashed_id')}?videoFoam=true' allowtransparency='true' frameborder='0' scrolling='no' class='wistia_embed' name='wistia_embed' allowfullscreen mozallowfullscreen webkitallowfullscreen oallowfullscreen msallowfullscreen width='320' height='180'></iframe><script src='//fast.wistia.net/assets/external/iframe-api-v1.js'></script>"
  ).property()
