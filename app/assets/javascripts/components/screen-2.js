Easypeasy.Screen2Component = Ember.Component.extend({
  gestures: {
    swipeLeft: function (event) {
      this.sendAction('swipedLeft');
      return false;
    },
    swipeRight: function (event) {
      this.sendAction('swipedRight');
      return false;
    },
    tap: function (event) {
      this.sendAction('swipedLeft');
      return false;
    }
  }
});
