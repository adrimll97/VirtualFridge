# frozen_string_literal: true

module FridgeIngredientsConcern
  extend ActiveSupport::Concern

  def create_fridge_ingredient!(ingredient_id)
    ingredient = Ingredient.find ingredient_id
    @fridge_ingredient = build_fridge_ingredient(ingredient)
    @fridge_ingredient.save!
  rescue ActiveRecord::RecordNotFound => _e
    raise $ERROR_INFO, 'No se ha encontrado el ingrediente'
  rescue StandardError => e
    raise e
  end

  private

  def build_fridge_ingredient(ingredient)
    FridgeIngredient.new(
      fridge_id: @fridge.id,
      ingredient_id: ingredient.id,
      quantity_number: ingredient.quantity_number,
      quantity_unit: ingredient.quantity_unit
    )
  end
end
