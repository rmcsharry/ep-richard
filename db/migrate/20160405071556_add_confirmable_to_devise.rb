class AddConfirmableToDevise < ActiveRecord::Migration
  # Note: We cannot use change, as update_all would fail if we tried to rollback
  def up
    add_column :admins, :confirmation_token, :string
    add_column :admins, :confirmed_at, :datetime
    add_column :admins, :confirmation_sent_at, :datetime    
    add_index  :admins, :confirmation_token, unique: true
    
    # To avoid a short time window between running the migration and updating all existing
    # users as confirmed, do the following    
    Admin.update_all({:confirmed_at => DateTime.now, :confirmation_sent_at => DateTime.now})
    # All existing user accounts should be able to log in after this.
  end

  def down
    remove_columns :admins, :confirmation_token, :confirmed_at, :confirmation_sent_at
  end
end
