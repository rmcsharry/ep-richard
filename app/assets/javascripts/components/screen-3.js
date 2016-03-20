Easypeasy.Screen3Component = Ember.Component.extend({
  gestures: {
    swipeLeft: function (event) {
      this.sendAction('swipedLeft');
      return false; // return `false` to stop bubbling
    },
	tap: function (event) {
	  alert('tapped');
      this.sendAction('getStarted');
      return false; // return `false` to stop bubbling
    }    
  },
  
  actions: {
  	go: function() {
  	  this.sendAction('getStarted');
  	  return false;
  	}
  }
});