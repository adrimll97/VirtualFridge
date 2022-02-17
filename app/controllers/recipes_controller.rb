# frozen_string_literal: true

RECIPES_PER_PAGE = 24

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

  private

  def set_recipe
    @recipe = Recipe.find(params[:id])
  end
end
