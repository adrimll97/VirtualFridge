# frozen_string_literal: true

class ShoppingCartIngredientsController < ApplicationController
  before_action :set_shopping_cart_ingredient, only: %i[show update destroy]

  def show
    respond_to do |format|
      format.js { render 'show.js.erb' }
    end
  end

  def update
    fi_params = update_shopping_cart_ingredients_params
    begin
      @shopping_cart_ingredient.update!(fi_params)
      flash[:notice] = I18n.t(:edited_correctly, scope: :ingredients)
    rescue StandardError => _e
      flash[:alert] = @shopping_cart_ingredient.errors.full_messages
    end
    redirect_back(fallback_location: root_path)
  end

  def destroy
    begin
      @shopping_cart_ingredient.destroy!
      flash[:notice] = I18n.t(:removed_from_fridge, scope: :ingredients)
    rescue StandardError => _e
      flash[:alert] = @shopping_cart_ingredient.errors.full_messages
    end
    redirect_back(fallback_location: root_path)
  end

  private

  def set_shopping_cart_ingredient
    @shopping_cart_ingredient = ShoppingCartIngredient.find(params[:id])
  end

  def update_shopping_cart_ingredients_params
    params.require(:shopping_cart_ingredient).permit(:ingredient_id, :quantity_number)
  end
end
