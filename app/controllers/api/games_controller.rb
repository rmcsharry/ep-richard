module API
  class GamesController < ApplicationController

    def index
      games = Game.where("in_default_set = true")
      if parent = Parent.find(params[:parent])
        games = games + Game.getExtraGamesForParent(parent)
      end
      render json: games, status: 200
    end

    def show
      game = Game.find(params[:id])
      render json: game, status: 200
    end

  end
end
