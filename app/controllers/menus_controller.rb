# frozen_string_literal: true

MENUS_PER_PAGE = 20

class MenusController < ApplicationController
  before_action :set_menu, only: %i[show destroy]

  def index
    @menus = Menu.all.page(params[:page]).per(MENUS_PER_PAGE)
  end

  def show
    @lunchs_number = @menu.lunchs_number
    @dinners_number = @menu.dinners_number
    @lunchs_per_day = @menu.lunchs_per_day
    @dinners_per_day = @menu.dinners_per_day
  end

  def destroy
    @menu.destroy!
    flash[:notice] = I18n.t(:menu_destroy, scope: :menus)
  rescue StandardError => _e
    flash[:alert] = @menu.errors.full_messages
  ensure
    redirect_to user_path(current_user.id)
  end

  private

  def set_menu
    @menu = Menu.find(params[:id])
  end
end
