class AddInactiveDateToPod < ActiveRecord::Migration
  def change
    add_column :pods, :inactive_date, :date
  end
end
