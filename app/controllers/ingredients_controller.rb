# frozen_string_literal: true

INGREDIENTS_PER_PAGE = 20

class IngredientsController < ApplicationController
  include FridgeIngredientsConcern
  include ShoppingCartIngredientsConcern

  before_action :set_ingredient, only: %i[show]

  # GET /ingredients or /ingredients.json
  def index
    @ingredients = Ingredient.all.page(params[:page]).per(INGREDIENTS_PER_PAGE)
  end

  # GET /ingredients/1 or /ingredients/1.json
  def show
    respond_to do |format|
      format.js { render 'show' }
    end
  end

  def search
    name = search_params['search'].downcase
    page = search_params['page']
    @ingredients = Ingredient.where('lower(name) LIKE :search', search: "%#{name}%")
                             .page(page).per(INGREDIENTS_PER_PAGE)
    respond_to do |format|
      format.html { render 'index' }
      format.json { render json: build_ingredients_json }
    end
  end

  def create_user_ingredient
    ui_params = user_ingredient_params
    begin
      if ui_params['fridge'].present?
        create_fridge_ingredient!(ui_params[:id].to_i)
        message = I18n.t(:added_to_fridge, scope: :ingredients)
      else
        create_shopping_cart_ingredient!(ui_params[:id].to_i)
        message = I18n.t(:added_to_shop_cart, scope: :ingredients)
      end
      flash[:notice] = message
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
    params.permit(:search, :page)
  end

  def user_ingredient_params
    params.permit(:id, :fridge, :shopping_cart)
  end

  def build_ingredients_json
    data = @ingredients.map do |ingredient|
      {
        id: ingredient.id,
        name: ingredient.name,
        image_url: ingredient.image_url || ActionController::Base.helpers.image_url('default-ingredients.png'),
        q_number: ingredient.quantity_number,
        q_unit: ingredient.quantity_unit
      }
    end
    { ingredients: data, total_count: @ingredients.total_count }
  end
end
