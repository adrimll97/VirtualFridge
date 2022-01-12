# frozen_string_literal: true

class FridgeIngredientsController < ApplicationController
  before_action :set_fridge_ingredient, only: %i[show edit update]

  def show
    respond_to do |format|
      format.js { render 'show.js.erb' }
    end
  end

  def create
    ingredient_id = fridge_ingredients_params[:ingredient_id]
    ingredient = Ingredient.find ingredient_id

    fridge_ingredient = build_fridge_ingredient(ingredient)
    if fridge_ingredient.save
      redirect_to(ingredients_path)
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def edit
    @fridge_ingredient
  end

  def update
    fi_params = update_fridge_ingredients_params
    if @fridge_ingredient.update(fi_params)
      redirect_back(fallback_location: root_path)
    else
      render :edit
    end
  end

  private

  def set_fridge_ingredient
    @fridge_ingredient = FridgeIngredient.find(params[:id])
  end

  def fridge_ingredients_params
    params.permit(:ingredient_id)
  end

  def update_fridge_ingredients_params
    params.require(:fridge_ingredient).permit(:ingredient_id, :expiration_date, :quantity_number)
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
