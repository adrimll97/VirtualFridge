# frozen_string_literal: true

class Menu < ApplicationRecord
  belongs_to :user
  has_many :menu_recipes, dependent: :destroy

  def lunchs_number
    menu_recipes.lunch.count
  end

  def dinners_number
    menu_recipes.dinner.count
  end
end
