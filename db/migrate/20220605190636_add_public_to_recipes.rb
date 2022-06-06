class AddPublicToRecipes < ActiveRecord::Migration[6.1]
  def change
    add_column :recipes, :public, :boolean, null: false, default: false
  end
end
