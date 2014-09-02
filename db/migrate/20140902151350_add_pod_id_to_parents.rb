class AddPodIdToParents < ActiveRecord::Migration
  def change
    add_column :parents, :pod_id, :integer
  end
end
