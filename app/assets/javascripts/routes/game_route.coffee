Easypeasy.GameRoute = Ember.Route.extend(Easypeasy.ResetScroll, {
  model: (params) ->
    myGame = this.store.fetchById('game', params.game_id);
    myGame.reload;
    return myGame;
});
