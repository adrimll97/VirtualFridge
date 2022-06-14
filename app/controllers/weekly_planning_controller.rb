# frozen_string_literal: true

class WeeklyPlanningController < ApplicationController
  before_action :set_weekly_planning, only: %i[index]

  def index
    @lunchs_number = @weekly_planning.lunchs_number
    @dinners_number = @weekly_planning.dinners_number
    @lunchs_per_day = @weekly_planning.lunchs_per_day
    @dinners_per_day = @weekly_planning.dinners_per_day
  end

  private

  def set_weekly_planning
    @weekly_planning = WeeklyPlanning.find_or_create_by(user_id: current_user.id)
  end
end
