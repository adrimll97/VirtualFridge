# frozen_string_literal: true

class Menu < ApplicationRecord
  belongs_to :user
  has_many :menu_recipes, dependent: :destroy
end
