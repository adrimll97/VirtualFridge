# frozen_string_literal: true

class Recipe < ApplicationRecord
  mount_uploader :image, ImageUploader
  serialize :steps, Array

  belongs_to :user
  has_many :recipe_ingredients, dependent: :destroy

  validates :user, presence: true
end
