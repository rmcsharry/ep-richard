class PodAdmin::GamesController < PodAdminController

  def index
    @default_games = Game.default
    @weekly_games = Game.non_default
  end

end
