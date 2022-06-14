# frozen_string_literal: true

RECIPES_PER_PAGE = 24

class RecipesController < ApplicationController
  include ShowDeleteable

  before_action :set_recipe, only: %i[show edit update destroy change_privacity change_favority]
  before_action :set_favorite_recipe, only: %i[show change_favority]

  def index
    @recipes = Recipe.public_recipes.page(params[:page]).per(RECIPES_PER_PAGE)
  end

  def show
    session[:prev_url_recipe] = request.referer
    @is_favorite = @favorite_recipe.present?
  end

  def new
    @recipe = Recipe.new
  end

  def edit
    @recipe
  end

  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.user_id = current_user.id
    begin
      @recipe.save!
      flash[:notice] = I18n.t(:recipe_created, scope: :recipes)
      redirect_to user_path(current_user.id)
    rescue StandardError => _e
      flash[:alert] = @recipe.errors.full_messages
      render :new
    end
  end

  def update
    @recipe.update!(recipe_params)
    flash[:notice] = I18n.t(:recipe_updated, scope: :recipes)
    redirect_to recipe_path(@recipe)
  rescue StandardError => _e
    flash[:alert] = @recipe.errors.full_messages
    render :edit
  end

  def destroy
    @recipe.destroy!
    flash[:notice] = I18n.t(:recipe_destroy, scope: :recipes)
  rescue ActiveRecord::InvalidForeignKey => _e
    flash[:alert] = 'No se ha podido borrar la receta por que se está usando en algún menú'
  rescue StandardError => _e
    flash[:alert] = @recipe.errors.full_messages
  ensure
    if delete_from_show?(recipe_path)
      redirect_to session[:prev_url_recipe]
    else
      redirect_back(fallback_location: user_path(current_user.id))
    end
  end

  def search
    name = search_params['search'].downcase
    page = search_params['page']
    @recipes = Recipe.public_recipes.joins(recipe_ingredients: :ingredient)
                     .where('lower(recipes.name) LIKE :search OR lower(ingredients.name) LIKE :search',
                            search: "%#{name}%")
                     .distinct.page(page).per(RECIPES_PER_PAGE)

    respond_to do |format|
      format.html { render 'index' }
      format.json { render json: build_recipes_json }
    end
  end

  def change_privacity
    @recipe.update!(public: !@recipe.public?)
    flash[:notice] = if !@recipe.public?
                       I18n.t(:privatized, scope: %i[recipes privacity confirm])
                     else
                       I18n.t(:publicated, scope: %i[recipes privacity confirm])
                     end
  rescue StandardError => _e
    flash[:alert] = @recipe.errors.full_messages
  ensure
    redirect_to recipe_path(@recipe)
  end

  def change_favority
    favorite_recipe = @favorite_recipe || FavoriteRecipe.create(user: current_user, recipe: @recipe)
    favorite_recipe.update!(favorite: !favorite_recipe.favorite?)
    flash[:notice] = if favorite_recipe.favorite?
                       I18n.t(:marked_favorite, scope: %i[recipes favorite confirm])
                     else
                       I18n.t(:unmarked_favorite, scope: %i[recipes favorite confirm])
                     end
  rescue StandardError => _e
    flash[:alert] = @recipe.errors.full_messages
  ensure
    redirect_to recipe_path(@recipe)
  end

  private

  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

  def set_favorite_recipe
    @favorite_recipe = FavoriteRecipe.of_user(current_user).of_recipe(@recipe).first
  end

  def recipe_params
    params.require('recipe').permit(
      :name, :image, steps: [], recipe_ingredients_attributes: %i[id ingredient_id quantity_number quantity_unit _destroy]
    )
  end

  def search_params
    params.permit(:search, :page)
  end

  def build_recipes_json
    data = @recipes.map do |recipe|
      {
        id: recipe.id,
        name: recipe.name,
        image_url: recipe.image_url || ActionController::Base.helpers.image_url('default-recipe.png'),
        author: recipe.user.name
      }
    end
    { recipes: data, total_count: @recipes.total_count }
  end
end
