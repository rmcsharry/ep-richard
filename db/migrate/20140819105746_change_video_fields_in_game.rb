class ChangeVideoFieldsInGame < ActiveRecord::Migration
  def change
    remove_column :games, :video_url_mp4
    remove_column :games, :video_url_webm
    add_column :games, :video_embed_code, :text
  end
end
