# frozen_string_literal: true

class RecipeIngredient < ApplicationRecord
  belongs_to :recipe
  belongs_to :ingredient

  validates :ingredient, uniqueness: { scope: :recipe }
  validates :recipe, :ingredient, :quantity_number, :quantity_unit, presence: true
end
