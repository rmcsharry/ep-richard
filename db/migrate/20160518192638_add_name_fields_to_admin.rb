class AddNameFieldsToAdmin < ActiveRecord::Migration
  def change
    add_column :admins, :name, :string, limit: 50
    add_column :admins, :preferred_name, :string, limit: 25
  end
end
