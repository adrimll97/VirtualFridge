# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_fridge
  before_action :set_shopping_cart

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  def set_fridge
    return unless user_signed_in?

    @fridge = Fridge.find_or_create_by(user_id: current_user.id)
  end

  def set_shopping_cart
    return unless user_signed_in?

    @shopping_cart = ShoppingCart.find_or_create_by(user_id: current_user.id)
  end
end
