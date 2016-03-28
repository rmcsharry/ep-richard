Easypeasy.Screen1Component = Ember.Component.extend({
  gestures: {
    swipeLeft: function (event) {
      this.sendAction('swipedLeft');
      return false;
    },
    tap: function (event) {
      this.sendAction('swipedLeft');
      return false;
    },    
  }
});
