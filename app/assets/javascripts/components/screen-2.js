Easypeasy.Screen2Component = Ember.Component.extend({
  gestures: {
    swipeRight: function (event) {
      this.sendAction('swipedRight');
      return false; // return `false` to stop bubbling
    },
    swipeLeft: function (event) {
      this.sendAction('swipedLeft');
      return false; // return `false` to stop bubbling
    }    
  }
});
