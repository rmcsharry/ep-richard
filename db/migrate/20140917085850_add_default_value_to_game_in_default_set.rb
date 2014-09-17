class AddDefaultValueToGameInDefaultSet < ActiveRecord::Migration
  def up
    change_column :games, :in_default_set, :boolean, :default => false
  end

  def down
    change_column :games, :in_default_set, :boolean, :default => nil
  end
end
