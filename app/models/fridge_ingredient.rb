# frozen_string_literal: true

class FridgeIngredient < ApplicationRecord
  belongs_to :fridge
  belongs_to :ingredient

  validates :fridge, uniqueness: { scope: :ingredient }
end
