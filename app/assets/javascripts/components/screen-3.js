Easypeasy.Screen3Component = Ember.Component.extend({
  gestures: {
    swipeLeft: function (event) {
      this.sendAction('swipedLeft');
      return false; // return `false` to stop bubbling
    },
	tap: function (event) {
      this.sendAction('getStarted');
      return false; // return `false` to stop bubbling
    }    
  }

});