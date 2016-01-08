class AddLastNotifiedToAdmin < ActiveRecord::Migration
  def change
    add_column :admins, :last_analytics_email_sent, :datetime
  end
end
