class AddDescriptionToPod < ActiveRecord::Migration
  def change
    add_column :pods, :description, :string
  end
end
