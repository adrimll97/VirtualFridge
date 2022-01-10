# frozen_string_literal: true

class FridgeIngredientsController < ApplicationController
  def create
    ingredient_id = fridge_ingredients_params[:ingredient_id]
    ingredient = Ingredient.find ingredient_id

    fridge_ingredient = build_fridge_ingredient(ingredient)
    if fridge_ingredient.save
      redirect_to(ingredients_path)
    else
      redirect_to :back
    end
  end

  private

  def fridge_ingredients_params
    params.permit(:ingredient_id)
  end

  def build_fridge_ingredient(ingredient)
    FridgeIngredient.new(
      fridge_id: @fridge.id,
      ingredient_id: ingredient.id,
      quantity_number: ingredient.quantity_number,
      quantity_unit: ingredient.quantity_unit
    )
  end
end
