# rails g migration AddImageUrlToGame image_url:string
class AddImageUrlToGame < ActiveRecord::Migration
  def change
    add_column :games, :image_url, :string
  end
end
