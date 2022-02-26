# frozen_string_literal: true

RECIPES_PER_PAGE = 24

class UsersController < ApplicationController
  before_action :set_user, only: %i[show]

  # GET /users/1 or /users/1.json
  def show
    @recipes = Recipe.of_user(@user).page(params[:page]).per(RECIPES_PER_PAGE)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end
end
