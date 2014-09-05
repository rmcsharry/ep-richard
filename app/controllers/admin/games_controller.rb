class Admin::GamesController < AdminController

  def index
    @games = Game.order('id DESC')
  end
  
  def new
    @game = Game.new
  end

  def create
    @game = Game.new(game_params)
    if @game.save
      redirect_to admin_games_path
    else
      render 'new'
    end
  end

  def edit
    @game = Game.find(params[:id])
  end

  def update
    game = Game.find(params[:id])
    game.update!(game_params)
    redirect_to admin_games_path
  end

  def destroy
    game = Game.find(params[:id])
    game.delete
    redirect_to admin_games_path
  end

  private

    def game_params
      params.require(:game).permit(:name, :description, :instructions, :image_url, :video_embed_code)
    end

end
