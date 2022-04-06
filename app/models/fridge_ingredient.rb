# frozen_string_literal: true

class FridgeIngredient < ApplicationRecord
  belongs_to :fridge
  belongs_to :ingredient

  validates :ingredient, uniqueness: { scope: :fridge, message: I18n.t(:duplicated_in_fridge, scope: :ingredients) }
  validates :fridge, :ingredient, :quantity_number, :quantity_unit, presence: true

  def expired?
    return false unless expiration_date.present?

    Date.today > expiration_date
  end

  def close_expired?
    return false unless expiration_date.present?

    (Date.today...Date.today + 1.week).include?(expiration_date)
  end
end
