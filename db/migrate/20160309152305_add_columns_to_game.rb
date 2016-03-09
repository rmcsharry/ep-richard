class AddColumnsToGame < ActiveRecord::Migration
  def change
    add_column :games, :top_tip, :text
    add_column :games, :did_you_know_fact, :text
  end
end