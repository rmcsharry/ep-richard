Easypeasy.Screen1Component = Ember.Component.extend({
  gestures: {
    swipeRight: function (event) {
      this.sendAction('swipedRight');
      return false; // return `false` to stop bubbling
    },
  }
});
