# frozen_string_literal: true

class MenuRecipe < ApplicationRecord
  belongs_to :menu
  belongs_to :recipe

  enum type: { lunch: 0, dinner: 1 }
  enum day: { monday: 0, tuesday: 1, wednesday: 2, thursday: 3, friday: 4, saturday: 5, sunday: 6 }
end
