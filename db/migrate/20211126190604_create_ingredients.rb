class CreateIngredients < ActiveRecord::Migration[6.1]
  def change
    create_table :ingredients do |t|
      t.string :name, null: false
      t.text :url, null: false
      t.string :image_url
      t.float :quantity_number, null: false
      t.string :quantity_unit, null: false

      t.timestamps
    end
  end
end
