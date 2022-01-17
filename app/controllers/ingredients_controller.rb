# frozen_string_literal: true

INGREDIENTS_PER_PAGE = 24

class IngredientsController < ApplicationController
  include FridgeIngredientsConcern

  before_action :set_ingredient, only: %i[show]

  # GET /ingredients or /ingredients.json
  def index
    @ingredients = Ingredient.all.page(params[:page]).per(INGREDIENTS_PER_PAGE)
  end

  # GET /ingredients/1 or /ingredients/1.json
  def show
    respond_to do |format|
      format.js { render 'show.js.erb' }
    end
  end

  def search
    name = search_params['search'].downcase
    if name.present?
      @ingredients = Ingredient.where('lower(name) LIKE :search', search: "%#{name}%")
                               .page(params[:page]).per(INGREDIENTS_PER_PAGE)
      render 'index'
    else
      redirect_to action: :index
    end
  end

  def create_user_ingredient
    ui_params = user_ingredient_params
    begin
      create_fridge_ingredient!(ui_params[:id].to_i) if ui_params['fridge'].present?
      flash[:notice] = I18n.t(:added_to_fridge, scope: :ingredients)
    rescue StandardError => e
      flash[:alert] = e.message
    end
    redirect_back(fallback_location: ingredients_path)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_ingredient
    @ingredient = Ingredient.find(params[:id])
  end

  def search_params
    params.permit(:search)
  end

  def user_ingredient_params
    params.permit(:id, :fridge, :shopping_cart)
  end
end
