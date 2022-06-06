# frozen_string_literal: true

RECIPES_PER_PAGE = 24

class HomeController < ApplicationController
  def index
    return redirect_to recipes_path unless user_signed_in?

    @recipes = Recipe.where(id: available_recipes).page(params[:page]).per(RECIPES_PER_PAGE)
  end

  private

  def available_recipes
    available_recipe_ids = []
    ingredients = @fridge.fridge_ingredients.pluck(:ingredient_id)
    recipes_with_owned_ingredients = Recipe.public_recipes.includes(:recipe_ingredients)
                                           .where(recipe_ingredients: { ingredient_id: ingredients })
    recipes_with_owned_ingredients.find_each do |recipe|
      next unless all_ingredients?(recipe)
      next unless all_amounts?(recipe)

      available_recipe_ids << recipe.id
    end
    available_recipe_ids
  end

  def all_ingredients?(recipe)
    all_recipe_ingredients = recipe.recipe_ingredients.count
    owned_recipe_ingredients = recipe.recipe_ingredients.size
    all_recipe_ingredients == owned_recipe_ingredients
  end

  def all_amounts?(recipe)
    recipe.recipe_ingredients.each do |recipe_ingredient|
      fridge_ingredient = @fridge.fridge_ingredients.find_by(ingredient_id: recipe_ingredient.ingredient_id)
      return false if recipe_ingredient.quantity_number > fridge_ingredient.quantity_number
    end
    true
  end
end
