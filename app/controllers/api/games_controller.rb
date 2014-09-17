module API
  class GamesController < ApplicationController

    def index
      games = Game.where("in_default_set = true")
      if params[:parent]
        if parent = Parent.find(params[:parent])
          if pod = parent.pod
            if pod.go_live_date
              pod_go_live_date = Date.parse(parent.pod.go_live_date.to_s)
              number_of_weeks_since_go_live = ((Date.today - pod_go_live_date)/7).to_i
              non_default_games = Game.where("in_default_set = false").order("created_at ASC")
              extra_games = non_default_games[0, number_of_weeks_since_go_live]
              games = games + extra_games
            end
          end
        end
      end
      render json: games, status: 200
    end

    def show
      game = Game.find(params[:id])
      render json: game, status: 200
    end

  end
end
