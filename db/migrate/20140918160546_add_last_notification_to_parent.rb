class AddLastNotificationToParent < ActiveRecord::Migration
  def change
    add_column :parents, :last_notification, :datetime
  end
end
