Easypeasy.GameController = Ember.Controller.extend
  needs: ['application', 'parent', 'comments']
  application: Ember.computed.alias("controllers.application")
  parent: Ember.computed.alias('controllers.parent.model')
   
  commentsCount: ( ->
    count = @get('model.comments.length')
    if count == 1
      "#{count} comment"
    else
      "#{count} comments"
  ).property('model.comments.length')
