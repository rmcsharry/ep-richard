require 'redcarpet'

class PodAdmin::GamesController < PodAdminController

  def index
    @default_games = Game.default
    @weekly_games = Game.non_default
  end

  def show
    @game = Game.find(params[:id])

    if @game.instructions
      renderer = Redcarpet::Render::HTML.new(no_links: true, hard_wrap: true)
      @instructions = Redcarpet::Markdown.new(renderer).render(@game.instructions).html_safe
    else
      @instructions = ""
    end

  end

end
