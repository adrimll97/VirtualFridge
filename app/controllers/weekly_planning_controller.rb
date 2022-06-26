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
end
