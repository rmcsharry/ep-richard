class AddPodIdToAdmin < ActiveRecord::Migration
  def change
    add_column :admins, :pod_id, :integer
  end
end
