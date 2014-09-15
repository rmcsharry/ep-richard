module API
  class GamesController < ApplicationController

    def index
      games = Game.where("in_default_set = true")
      render json: games, status: 200
    end

    def show
      game = Game.find(params[:id])
      render json: game, status: 200
    end

  end
end
