# frozen_string_literal: true

class WeeklyPlanningController < ApplicationController
  before_action :set_weekly_planning, only: %i[index edit update use_menu]

  def index
    @lunchs_number = @weekly_planning.lunchs_number
    @dinners_number = @weekly_planning.dinners_number
    @lunchs_per_day = @weekly_planning.lunchs_per_day
    @dinners_per_day = @weekly_planning.dinners_per_day
  end

  def edit
    @lunchs_per_day = @weekly_planning.lunchs_per_day
    @dinners_per_day = @weekly_planning.dinners_per_day
  end

  def update
    @weekly_planning.update!(weekly_planning_params)
    weekly_planning_params[:weekly_planning_recipes_attributes].each do |_key, attrs|
      calculate_ingredients(attrs[:recipe_id])
    end
    flash[:notice] = I18n.t(:weekly_planning_updated, scope: :weekly_planning)
    redirect_to weekly_planning_index_path
  rescue StandardError => _e
    flash[:alert] = @weekly_planning.errors.full_messages
    render :edit
  end

  def use_menu
    WeeklyPlanning.clear_weekly_planning_of_user(current_user)
    menu_recipes = MenuRecipe.where(menu_id: params[:menu])
    menu_recipes.each do |menu_recipe|
      data = {
        recipe_id: menu_recipe.recipe_id,
        day: menu_recipe.day,
        kind: menu_recipe.kind
      }
      @weekly_planning.weekly_planning_recipes.create!(data)
      calculate_ingredients(menu_recipe.recipe_id)
    end
    flash[:notice] = I18n.t(:use_confirmation, scope: %i[weekly_planning menu])
    redirect_to weekly_planning_index_path
  rescue StandardError => _e
    flash[:alert] = @weekly_planning.errors.full_messages
    redirect_back(fallback_location: weekly_planning_index_path)
  end

  private

  def set_weekly_planning
    @weekly_planning = WeeklyPlanning.find_or_create_by(user_id: current_user.id)
  end

  def weekly_planning_params
    weekly_planning_params = params.require('weekly_planning').permit(
      weekly_planning_recipes_attributes: %i[id recipe_id day kind _destroy]
    )
    weekly_planning_params[:weekly_planning_recipes_attributes].reject! do |_key, values|
      values[:recipe_id].blank?
    end
    weekly_planning_params
  end

  def calculate_ingredients(recipe_id)
    recipe = Recipe.find(recipe_id)
    recipe_ingredients = element_ingredients_hash(recipe.recipe_ingredients)
    fridge_ingredients = element_ingredients_hash(@fridge.fridge_ingredients)
    cart_ingredients = element_ingredients_hash(@shopping_cart.shopping_cart_ingredients)
    new_ingredients_hash = ingredients_to_buy_hash(recipe_ingredients, fridge_ingredients, cart_ingredients)
    new_ingredients_hash.each do |ingredient_id, quantity|
      ShoppingCartIngredient.create(shopping_cart_id: @shopping_cart.id, ingredient_id: ingredient_id,
                                    quantity_number: quantity.first, quantity_unit: quantity.last)
    end
  end

  def element_ingredients_hash(element_ingredients)
    ingredients_hash = {}
    element_ingredients.each do |ei|
      ingredient_id = ei.ingredient_id
      if ingredients_hash[ingredient_id].present?
        ingredients_hash[ingredient_id].first += ei.quantity_number
      else
        ingredients_hash[ingredient_id] = [ei.quantity_number, ei.quantity_unit]
      end
    end
    ingredients_hash
  end

  def ingredients_to_buy_hash(recipe_ingredients, fridge_ingredients, cart_ingredients)
    new_ingredients = {}
    recipe_ingredients.each do |ingredient_id, quantity|
      fridge_ingredient_quantity = fridge_ingredients[ingredient_id]&.first || 0
      cart_ingredient_quantity = cart_ingredients[ingredient_id]&.first || 0
      total = quantity.first - fridge_ingredient_quantity - cart_ingredient_quantity
      new_ingredients[ingredient_id] = [total, quantity.second] if total&.positive?
    end
    new_ingredients
  end
end
