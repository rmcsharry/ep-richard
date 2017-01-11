class AddSchoolIdToPods < ActiveRecord::Migration
  def change
    add_column :pods, :school_id, :string
  end
end
