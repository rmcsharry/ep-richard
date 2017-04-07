class AddEyfsFieldsToGames < ActiveRecord::Migration
  def change
    add_column :games, :eyfs_area, :string 
    add_column :games, :eyfs_goal, :string 
  end
end
