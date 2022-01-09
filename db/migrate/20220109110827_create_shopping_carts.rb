class CreateShoppingCarts < ActiveRecord::Migration[6.1]
  def change
    create_table :shopping_carts do |t|
      t.references :user, index: true, foreign_key: true

      t.timestamps
    end
  end
end
