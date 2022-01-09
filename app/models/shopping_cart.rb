class ShoppingCart < ApplicationRecord
  belongs_to :user
  has_many :shopping_cart_ingredients, dependent: :destroy

  validates :user, presence: true
  validates :user, uniqueness: true
end
