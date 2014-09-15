class AddInDefaultSetToGame < ActiveRecord::Migration
  def change
    add_column :games, :in_default_set, :boolean
  end
end
