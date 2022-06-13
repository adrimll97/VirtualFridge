# frozen_string_literal: true

class Menu < ApplicationRecord
  belongs_to :user
  has_many :menu_recipes, dependent: :destroy
  accepts_nested_attributes_for :menu_recipes, allow_destroy: true

  validates_presence_of :name

  scope :of_user, ->(user) { where(user_id: user&.id) }
  scope :public_menus, -> { where(public: true) }
  scope :private_menus, -> { where(public: false) }

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
    menu_recipes.send(kind).send(day)
  end
end
