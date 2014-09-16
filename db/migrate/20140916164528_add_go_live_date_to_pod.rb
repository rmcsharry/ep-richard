class AddGoLiveDateToPod < ActiveRecord::Migration
  def change
    add_column :pods, :go_live_date, :datetime
  end
end
