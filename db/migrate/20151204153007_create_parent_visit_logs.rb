class CreateParentVisitLogs < ActiveRecord::Migration
  def change
    create_table :parent_visit_logs do |t|
      t.integer :parent_id
      t.integer :pod_id

      t.timestamps
    end
  end
end
