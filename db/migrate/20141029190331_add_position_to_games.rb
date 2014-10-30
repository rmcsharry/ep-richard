class AddPositionToGames < ActiveRecord::Migration
  def change
    add_column :games, :position, :integer
  end
end
