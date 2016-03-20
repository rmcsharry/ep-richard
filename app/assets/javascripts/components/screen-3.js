Easypeasy.Screen3Component = Ember.Component.extend({
  gestures: {
    swipeRight: function (event) {
      this.sendAction('swipedRight');
      return false;
    },
	tap: function (event) {
      this.sendAction('getStarted');
      return false;
    }    
  }

});