# frozen_string_literal: true

module FridgeIngredientsConcern
  extend ActiveSupport::Concern

  def create_fridge_ingredient!(ingredient_id, quantity_number = nil, quantity_unit = nil)
    ingredient = Ingredient.find ingredient_id
    @fridge_ingredient = build_fridge_ingredient(ingredient, quantity_number, quantity_unit)
    @fridge_ingredient.save!
  rescue ActiveRecord::RecordNotFound => _e
    raise $ERROR_INFO, 'No se ha encontrado el ingrediente'
  rescue StandardError => e
    raise e
  end

  private

  def build_fridge_ingredient(ingredient, quantity_number = nil, quantity_unit = nil)
    FridgeIngredient.new(
      fridge_id: @fridge.id,
      ingredient_id: ingredient.id,
      quantity_number: quantity_number || ingredient.quantity_number,
      quantity_unit: quantity_unit || ingredient.quantity_unit
    )
  end
end
