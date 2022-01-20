class CreateRecipeIngredients < ActiveRecord::Migration[6.1]
  def change
    create_table :recipe_ingredients do |t|
      t.references :recipe, null: false, foreign_key: true
      t.references :ingredient, null: false, foreign_key: true
      t.float :quantity_number, null: false
      t.string :quantity_unit, null: false

      t.timestamps
    end

    add_index(:recipe_ingredients, %i[recipe_id ingredient_id], unique: true)
  end
end
