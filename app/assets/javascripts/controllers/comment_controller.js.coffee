Easypeasy.CommentsController = Ember.ArrayController.extend
  body: ''
  actions:
    addComment: ->
      comment = @store.createRecord('comment', ->
        body: @get('body')
      )
      comment.save()
