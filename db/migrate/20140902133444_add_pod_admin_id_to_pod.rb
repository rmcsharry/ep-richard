class AddPodAdminIdToPod < ActiveRecord::Migration
  def change
    add_column :pods, :pod_admin_id, :integer
  end
end
