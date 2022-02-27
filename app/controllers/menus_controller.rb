# frozen_string_literal: true

MENUS_PER_PAGE = 20

class MenusController < ApplicationController
  def index
    @menus = Menu.all.page(params[:page]).per(MENUS_PER_PAGE)
  end
end
