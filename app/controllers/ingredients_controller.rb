# frozen_string_literal: true

class IngredientsController < ApplicationController
  before_action :set_ingredient, only: %i[show]

  # GET /ingredients or /ingredients.json
  def index
    @ingredients = Ingredient.all.page params[:page]
  end

  # GET /ingredients/1 or /ingredients/1.json
  def show
    @ingredient
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_ingredient
    @ingredient = Ingredient.find(params[:id])
  end
end
