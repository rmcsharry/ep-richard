class ChangeGameDescriptionToText < ActiveRecord::Migration
  def change
    change_column :games, :description,  :text
  end
end
