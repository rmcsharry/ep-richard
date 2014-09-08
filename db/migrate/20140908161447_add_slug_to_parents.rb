class AddSlugToParents < ActiveRecord::Migration
  def change
    add_column :parents, :slug, :string
  end
end
