# frozen_string_literal: true

class FridgeIngredientsController < ApplicationController
  include ErrorHandler

  before_action :set_fridge_ingredient, only: %i[show edit update]

  def show
    respond_to do |format|
      format.js { render 'show.js.erb' }
    end
  end

  def update
    fi_params = update_fridge_ingredients_params
    @fridge_ingredient.update!(fi_params)
    redirect_back(fallback_location: root_path)
  rescue StandardError => _e
    error_js(@fridge_ingredient.errors.full_messages)
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
end
