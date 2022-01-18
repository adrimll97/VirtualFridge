# frozen_string_literal: true

class ShoppingCartIngredientsController < ApplicationController
  before_action :set_shopping_cart_ingredient, only: %i[show update destroy]

  def show
    respond_to do |format|
      format.js { render 'show.js.erb' }
    end
  end

  private

  def set_shopping_cart_ingredient
    @shopping_cart_ingredient = ShoppingCartIngredient.find(params[:id])
  end
end
