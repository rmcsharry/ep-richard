Ember.Handlebars.registerBoundHelper('format-date', function(value) {
  return value.toLocaleDateString();
});