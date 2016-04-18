class Admin::GamesController < AdminController

  def index
    @default_games = Game.default
    @weekly_games = Game.non_default
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.new(game_params)
    if @game.publish
      flash[:success] = "New game successfully added!"
      redirect_to admin_games_path
    else
      render 'new'
    end
  end

  def edit
    @game = Game.find(params[:id])
  end

  def update
    @game = Game.find(params[:id])
    @game.update(game_params)

    if @game.publish
      flash[:success] = "Game successfully updated!"
      redirect_to admin_games_path
    else
      render 'edit'
    end

  end

  def destroy
    game = Game.find(params[:id])
    game.delete
    redirect_to admin_games_path
  end

  private

    def game_params
      params.require(:game).permit(:name, :description, :instructions, :did_you_know_fact, :top_tip, :video_url, :image_url, :position, :in_default_set)
    end

end
