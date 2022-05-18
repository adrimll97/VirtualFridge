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

  def lunchs_per_day
    {
      0 => recipes_per_kind_day('lunch', 'monday'),
      1 => recipes_per_kind_day('lunch', 'tuesday'),
      2 => recipes_per_kind_day('lunch', 'wednesday'),
      3 => recipes_per_kind_day('lunch', 'thursday'),
      4 => recipes_per_kind_day('lunch', 'friday'),
      5 => recipes_per_kind_day('lunch', 'saturday'),
      6 => recipes_per_kind_day('lunch', 'sunday')
    }
  end

  def dinners_per_day
    {
      0 => recipes_per_kind_day('dinner', 'monday'),
      1 => recipes_per_kind_day('dinner', 'tuesday'),
      2 => recipes_per_kind_day('dinner', 'wednesday'),
      3 => recipes_per_kind_day('dinner', 'thursday'),
      4 => recipes_per_kind_day('dinner', 'friday'),
      5 => recipes_per_kind_day('dinner', 'saturday'),
      6 => recipes_per_kind_day('dinner', 'sunday')
    }
  end

  private

  def recipes_per_kind_day(kind, day)
    recipes = menu_recipes.send(kind).send(day)
    recipes.map(&:recipe)
  end
end
