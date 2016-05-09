module API
  class GamesController < ApplicationController

    def index
      games = Game.where("in_default_set = true")
      if params[:parent]
        games = games + Game.getExtraGamesForParentSlug(params[:parent])
        parent = Parent.find_by_slug(params[:parent])
        session[:slug] = parent.slug
      end
      render json: games, each_serializer: GameIndexSerializer, status: 200
    end

    def show
      game = Game.find(params[:id])
      parent = Parent.find_by_slug(session[:slug])
      if parent
        render json: game, serializer: GameShowSerializer, root: :game, pod_id: parent.pod.id, status: 200
      else
        render json: game, serializer: GameShowSerializer, root: :game, status: 200
      end
    end

  end
end
