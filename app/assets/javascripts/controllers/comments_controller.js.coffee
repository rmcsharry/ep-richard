Easypeasy.CommentsController = Ember.ArrayController.extend
  needs: ['game', 'parent']
  game:   Ember.computed.alias("controllers.game")
  parent: Ember.computed.alias("controllers.parent")

  body:   ''
  commentsCount: ( ->
    count = @get('model.length')
    if count == 1
      "#{count} comment"
    else
      "#{count} comments"
  ).property('model.length')

  actions:
    addComment: ->
      unless !@get('body').trim()
        comment = @store.createRecord('comment',
          body: @get('body'),
          game_id: @get('game.id')
          parent_id: @get('parent.id')
        )

        controller = this

        @addObject(comment)

        success = ( -> controller.set('body', ''))
        failure = ( -> console.log "Failed to save comment")

        comment.save().then(success, failure)
