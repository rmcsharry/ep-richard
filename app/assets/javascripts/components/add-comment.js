Easypeasy.AddCommentComponent = Ember.Component.extend({

  body: '',
  actions: {
    addComment: function() {
      
      var comment, failure, success;
      var self = this;
      if (!!this.get('body').trim()) {
        comment = this.store.createRecord('comment', {
          body: this.get('body'),
          game: this.get('game'),
          parent_id: this.get('parent_id'),
          parent_name: this.get('parent_name')
        });
        
        success = (function() {
          self.set('body', '');
        });
        failure = (function() {
          return console.log("Failed to save comment");
        });
        return comment.save().then(success, failure);
      }
    }
  }
});