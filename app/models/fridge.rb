# frozen_string_literal: true

class Fridge < ApplicationRecord
  belongs_to :user
  has_many :fridge_ingredients, dependent: :destroy

  validates :user, presence: true
  validates :user, uniqueness: true
end
