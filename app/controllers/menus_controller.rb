# frozen_string_literal: true

MENUS_PER_PAGE = 10

class MenusController < ApplicationController
  include ShowDeleteable

  before_action :set_menu, only: %i[show edit update destroy change_privacity]

  def index
    @menus = Menu.public_menus.page(params[:page]).per(MENUS_PER_PAGE)
  end

  def show
    @lunchs_number = @menu.lunchs_number
    @dinners_number = @menu.dinners_number
    @lunchs_per_day = @menu.lunchs_per_day
    @dinners_per_day = @menu.dinners_per_day
    session[:prev_url_menu] = request.referer
  end

  def new
    @menu = Menu.new
  end

  def edit
    @lunchs_per_day = @menu.lunchs_per_day
    @dinners_per_day = @menu.dinners_per_day
  end

  def create
    @menu = Menu.new(menu_params)
    @menu.user_id = current_user.id
    begin
      @menu.save!
      flash[:notice] = I18n.t(:menu_created, scope: :menus)
      redirect_to user_path(current_user.id)
    rescue StandardError => _e
      flash[:alert] = @menu.errors.full_messages
      render :new
    end
  end

  def update
    @menu.update!(menu_params)
    flash[:notice] = I18n.t(:menu_updated, scope: :menus)
    redirect_to menu_path(@menu)
  rescue StandardError => _e
    flash[:alert] = @menu.errors.full_messages
    render :edit
  end

  def destroy
    @menu.destroy!
    flash[:notice] = I18n.t(:menu_destroy, scope: :menus)
  rescue StandardError => _e
    flash[:alert] = @menu.errors.full_messages
  ensure
    if delete_from_show?(menu_path)
      redirect_to session[:prev_url_menu]
    else
      redirect_back(fallback_location: user_path(current_user.id))
    end
  end

  def search
    name = search_params['search'].downcase
    page = search_params['page']
    @menus = Menu.public_menus
                 .where('lower(name) LIKE :search', search: "%#{name}%")
                 .distinct.page(page).per(MENUS_PER_PAGE)
    render 'index'
  end

  def change_privacity
    @menu.update!(public: !@menu.public?)
    flash[:notice] = if !@menu.public?
                       I18n.t(:privatized, scope: %i[menus privacity confirm])
                     else
                       I18n.t(:publicated, scope: %i[menus privacity confirm])
                     end
  rescue StandardError => _e
    flash[:alert] = @menu.errors.full_messages
  ensure
    redirect_to menu_path(@menu)
  end

  private

  def set_menu
    @menu = Menu.find(params[:id])
  end

  def menu_params
    menu_params = params.require('menu').permit(
      :name, :description, menu_recipes_attributes: %i[id recipe_id day kind _destroy]
    )
    menu_params[:menu_recipes_attributes].reject! do |_key, values|
      values[:recipe_id].blank?
    end
    menu_params
  end

  def search_params
    params.permit(:search, :page)
  end
end
