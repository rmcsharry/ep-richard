class AddVideoUrlsToGame < ActiveRecord::Migration
  def change
    add_column :games, :video_url_mp4, :string
    add_column :games, :video_url_webm, :string
  end
end
