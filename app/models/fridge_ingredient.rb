# frozen_string_literal: true

class FridgeIngredient < ApplicationRecord
  belongs_to :fridge
  belongs_to :ingredient

  validates :ingredient, uniqueness: { scope: :fridge, message: I18n.t(:duplicated_in_fridge, scope: :ingredients) }
  validates :fridge, :ingredient, :quantity_number, :quantity_unit, presence: true
end
