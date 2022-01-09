class ShoppingCartIngredient < ApplicationRecord
  belongs_to :shopping_cart
  belongs_to :ingredient

  validates :shopping_cart, uniqueness: { scope: :ingredient }
  validates :shopping_cart, :ingredient, :quantity_number, :quantity_unit, presence: true
end
