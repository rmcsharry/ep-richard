module API
  class LogController < ApplicationController

    def ping
      location = params[:location]
      if location
        path_elements = location.split("/")
        parent_slug = path_elements[1]
        game_or_games = path_elements[2]
        game_id = path_elements[3]
        if game_or_games == "games"
          logIndexVisit(parent_slug)
        elsif game_or_games == "game"
          logGameVisit(parent_slug, game_id)
        end
      end
      render json: [], status: 200
    end

    private

    def logIndexVisit(parent_slug)
      parent = Parent.find_by_slug(parent_slug)
      if parent
        log = ParentVisitLog.new
        log.parent_id = parent.id
        log.pod_id = parent.pod.id
        log.save
      end
    end

    def logGameVisit(parent_slug, game_id)
      parent = Parent.find_by_slug(parent_slug)
      game   = Game.find_by_id(game_id)
      if parent && game
        log = ParentVisitLog.new
        log.parent_id = parent.id
        log.pod_id = parent.pod.id
        log.game_id = game.id
        log.save
      end
    end

  end
end
