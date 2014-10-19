class AddWelcomeSmsSentToParent < ActiveRecord::Migration
  def change
    add_column :parents, :welcome_sms_sent, :boolean, :default => false
  end
end
