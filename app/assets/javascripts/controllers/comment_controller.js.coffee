Easypeasy.CommentsController = Ember.ArrayController.extend

  needs: ['game', 'parent']
  game:   Ember.computed.alias("controllers.game")
  parent: Ember.computed.alias("controllers.parent")
  body:   ''

  actions:
    addComment: ->
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
