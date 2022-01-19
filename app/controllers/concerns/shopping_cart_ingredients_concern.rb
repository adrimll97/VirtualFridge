# frozen_string_literal: true

module ShoppingCartIngredientsConcern
  extend ActiveSupport::Concern

  def create_shopping_cart_ingredient!(ingredient_id)
    ingredient = Ingredient.find ingredient_id
    @shopping_cart_ingredient = build_shopping_cart_ingredient(ingredient)
    @shopping_cart_ingredient.save!
  rescue ActiveRecord::RecordNotFound => _e
    raise $ERROR_INFO, 'No se ha encontrado el ingrediente'
  rescue StandardError => e
    raise e
  end

  private

  def build_shopping_cart_ingredient(ingredient)
    ShoppingCartIngredient.new(
      shopping_cart_id: @shopping_cart.id,
      ingredient_id: ingredient.id,
      quantity_number: ingredient.quantity_number,
      quantity_unit: ingredient.quantity_unit
    )
  end
end
