Ember.Handlebars.registerBoundHelper('format-time', function(value) {
  return value.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
});