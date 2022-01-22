# frozen_string_literal: true

RECIPES_PER_PAGE = 24

# Controlador de recetas
class RecipesController < ApplicationController
  def index
    @recipes = Recipe.all.page(params[:page]).per(RECIPES_PER_PAGE)
  end
end
