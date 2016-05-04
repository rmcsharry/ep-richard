Ember.onLoad('Ember.Application', function(Application) {
  Application.initializer({
    name: 'injectStoreIntoMyComponent',
    after: 'store',
    initialize: function(container, application) {
      application.inject('component:add-comment', 'store', 'store:application');
    }
  });
});
