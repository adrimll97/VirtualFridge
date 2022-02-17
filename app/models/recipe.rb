# frozen_string_literal: true

class Recipe < ApplicationRecord
  mount_uploader :image, ImageUploader
  serialize :steps, Array

  belongs_to :user
  has_many :recipe_ingredients, dependent: :destroy
  accepts_nested_attributes_for :recipe_ingredients, allow_destroy: true

  validates :user, :name, presence: true
end
