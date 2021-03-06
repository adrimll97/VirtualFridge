# frozen_string_literal: true

PER_PAGE = 24
class UsersController < ApplicationController
  before_action :set_user, only: %i[show]

  # GET /users/1 or /users/1.json
  def show
    @recipes = Recipe.of_user(@user).page(params[:page]).per(PER_PAGE)
    @favorite_recipes = @user.user_favorite_recipes.page(params[:page]).per(PER_PAGE)
    @menus = Menu.of_user(@user).page(params[:page]).per(PER_PAGE)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end
end
