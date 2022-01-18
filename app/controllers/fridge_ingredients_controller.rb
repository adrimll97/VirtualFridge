# frozen_string_literal: true

class FridgeIngredientsController < ApplicationController
  before_action :set_fridge_ingredient, only: %i[show update destroy]

  def show
    respond_to do |format|
      format.js { render 'show.js.erb' }
    end
  end

  def update
    fi_params = update_fridge_ingredients_params
    begin
      @fridge_ingredient.update!(fi_params)
      flash[:notice] = I18n.t(:edited_correctly, scope: :ingredients)
    rescue StandardError => _e
      flash[:alert] = @fridge_ingredient.errors.full_messages
    end
    redirect_back(fallback_location: root_path)
  end

  def destroy
    begin
      @fridge_ingredient.destroy!
      flash[:notice] = I18n.t(:removed_from_fridge, scope: :ingredients)
    rescue StandardError => _e
      flash[:alert] = @fridge_ingredient.errors.full_messages
    end
    redirect_back(fallback_location: root_path)
  end

  private

  def set_fridge_ingredient
    @fridge_ingredient = FridgeIngredient.find(params[:id])
  end

  def update_fridge_ingredients_params
    params.require(:fridge_ingredient).permit(:ingredient_id, :expiration_date, :quantity_number)
  end
end
