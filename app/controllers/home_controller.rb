class HomeController < ApplicationController
  def index
    redirect_to recipes_path unless user_signed_in?
  end
end
