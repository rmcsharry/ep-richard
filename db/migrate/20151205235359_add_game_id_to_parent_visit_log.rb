class AddGameIdToParentVisitLog < ActiveRecord::Migration
  def change
    add_column :parent_visit_logs, :game_id, :integer
  end
end
