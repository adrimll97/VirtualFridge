class CreateShoppingCartIngredients < ActiveRecord::Migration[6.1]
  def change
    create_table :shopping_cart_ingredients do |t|
      t.references :shopping_cart, foreign_key: true
      t.references :ingredient, foreign_key: true
      t.float :quantity_number, null: false
      t.string :quantity_unit, null: false

      t.timestamps
    end

    add_index(:shopping_cart_ingredients,
              %i[shopping_cart_id ingredient_id],
              unique: true,
              name: 'index_sci_on_shopping_cart_id_and_ingredient_id')
  end
end
