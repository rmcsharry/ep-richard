class CreatePods < ActiveRecord::Migration
  def change
    create_table :pods do |t|
      t.string :name

      t.timestamps
    end
  end
end
