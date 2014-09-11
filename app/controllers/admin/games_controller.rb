class Admin::GamesController < AdminController

  def index
    @games = Game.order('id DESC')
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.new(game_params)

    if @game.valid?
      video_url = params[:game][:video_url]
      embed_data = getEmbedDataFromVideoURL(video_url)
      if embed_data
        @game.image_url = embed_data["thumbnail_url"]
        @game.save
        redirect_to admin_games_path
      else
        flash[:notice] = "Oops. An error occured while talking to Wistia. Has the video finished encoding on Wistia? If so, wait a moment and try again."
        render 'new'
      end
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

    if @game.valid?
      video_url = params[:game][:video_url]
      embed_data = getEmbedDataFromVideoURL(video_url)
      @game.image_url = embed_data["thumbnail_url"]
      @game.save
      redirect_to admin_games_path
    else
      render 'new'
    end
  end

  def destroy
    game = Game.find(params[:id])
    game.delete
    redirect_to admin_games_path
  end

  private

    def game_params
      params.require(:game).permit(:name, :description, :instructions, :video_url, :image_url)
    end

    def getEmbedDataFromVideoURL(video_url)
      require 'net/http'
      url = URI.parse("http://fast.wistia.com/oembed?url=#{video_url}?videoFoam=true")
      req = Net::HTTP::Get.new(url.to_s)
      res = Net::HTTP.start(url.host, url.port) { |http|
          http.request(req)
      }
      begin
        json = JSON.parse(res.body)
        json["thumbnail_url"] = json["thumbnail_url"] + "&image_crop_resized=450x450"
        json["html"]
        json
      rescue JSON::ParserError
        false
      end
    end

end
