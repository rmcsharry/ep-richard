class AddVideoUrlToGame < ActiveRecord::Migration
  def change
    add_column :games, :video_url, :string
  end
end
