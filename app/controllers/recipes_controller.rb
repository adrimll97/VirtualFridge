# frozen_string_literal: true

RECIPES_PER_PAGE = 24
INGREDIENTS_PER_PAGE = 24

# Controlador de recetas
class RecipesController < ApplicationController
  before_action :set_recipe, only: %i[show]

  def index
    @recipes = Recipe.all.page(params[:page]).per(RECIPES_PER_PAGE)
  end

  def show
  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.user_id = current_user.id
    begin
      @recipe.save!
      flash[:notice] = 'Receta creada correctamente'
      redirect_to user_path(current_user.id)
    rescue StandardError => _e
      flash[:alert] = @recipe.errors.full_messages
      render :new
    end
  end

  def search_ingredients
    name = search_params['search'].downcase
    page = search_params['page']
    ingredients = Ingredient.where('lower(name) LIKE :search', search: "%#{name}%")
                            .page(page).per(INGREDIENTS_PER_PAGE)

    data = ingredients.map do |ingredient|
      {
        id: ingredient.id,
        name: ingredient.name,
        image_url: ingredient.image_url || ActionController::Base.helpers.image_url('default-ingredients.png'),
        q_number: ingredient.quantity_number,
        q_unit: ingredient.quantity_unit
      }
    end
    render json: { ingredients: data, total_count: ingredients.total_count }
  end

  private

  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

  def recipe_params
    params.require('recipe').permit(
      :name, :image, steps: [], recipe_ingredients_attributes: %i[id ingredient_id quantity_number quantity_unit _destroy]
    )
  end

  def search_params
    params.permit(:search, :page)
  end
end
