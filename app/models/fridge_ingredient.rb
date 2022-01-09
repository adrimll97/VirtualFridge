# frozen_string_literal: true

class FridgeIngredient < ApplicationRecord
  belongs_to :fridge
  belongs_to :ingredient

  validates :fridge, uniqueness: { scope: :ingredient }
  validates :fridge, :ingredient, :quantity_number, :quantity_unit, presence: true
end
