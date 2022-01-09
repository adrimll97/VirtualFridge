class CreateFridgeIngredients < ActiveRecord::Migration[6.1]
  def change
    create_table :fridge_ingredients do |t|
      t.references :fridge, foreign_key: true
      t.references :ingredient, foreign_key: true
      t.date :expiration_date
      t.float :quantity_number, null: false
      t.string :quantity_unit, null: false

      t.timestamps
    end

    add_index(:fridge_ingredients, %i[fridge_id ingredient_id], unique: true)
  end
end
