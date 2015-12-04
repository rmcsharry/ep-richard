module API
  class GamesController < ApplicationController

    def index
      games = Game.where("in_default_set = true")
      if params[:parent]
        games = games + Game.getExtraGamesForParentSlug(params[:parent])
        logVisit(params[:parent])
      end
      render json: games, status: 200
    end

    def show
      game = Game.find(params[:id])
      render json: game, status: 200
    end

    private

    def logVisit(parent_id)
      parent = Parent.find_by_slug(parent_id)
      if parent
        log = ParentVisitLog.new
        log.parent_id = parent.id
        log.pod_id = parent.pod.id
        log.save
      end
    end

  end
end
