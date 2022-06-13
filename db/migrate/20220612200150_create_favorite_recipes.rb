class CreateFavoriteRecipes < ActiveRecord::Migration[6.1]
  def change
    create_table :favorite_recipes do |t|
      t.references :user, index: true, foreign_key: true
      t.references :recipe, index: true, foreign_key: true
      t.boolean :favorite, null: false, default: false

      t.timestamps
    end
  end
end
