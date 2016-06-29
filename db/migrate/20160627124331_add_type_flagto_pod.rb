class AddTypeFlagtoPod < ActiveRecord::Migration
  def change
    add_column :pods, :is_test, :boolean, default: false
  end
end
