Easypeasy.Screen3Component = Ember.Component.extend({
  gestures: {
    swipeRight: function (event) {
      this.sendAction('swipedRight');
      return false; // return `false` to stop bubbling
    },
	tap: function (event) {
      this.sendAction('getStarted');
      return false; // return `false` to stop bubbling
    }    
  }

});