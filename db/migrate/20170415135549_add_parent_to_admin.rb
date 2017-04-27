class AddParentToAdmin < ActiveRecord::Migration
  def change
    add_column :admins, :parent_id, :integer
    add_index :admins, :parent_id, :unique => true
  end
end
