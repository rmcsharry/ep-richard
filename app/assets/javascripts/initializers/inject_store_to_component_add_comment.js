Ember.onLoad('Ember.Application', function(Application) {
  Application.initializer({
    name: 'injectStoreIntoAddComment',
    after: 'store',
    initialize: function(container, application) {
      application.inject('component:add-comment', 'store', 'store:application');
    }
  });
});
