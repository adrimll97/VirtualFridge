# frozen_string_literal: true

class Recipe < ApplicationRecord
  mount_uploader :image, ImageUploader
  serialize :steps, Array

  belongs_to :user
  has_many :recipe_ingredients, dependent: :destroy
  accepts_nested_attributes_for :recipe_ingredients, allow_destroy: true
  has_many :favorite_recipes, dependent: :destroy

  validates :user, :name, presence: true

  scope :of_user, ->(user) { where(user_id: user.id) }
  scope :public_recipes, -> { where(public: true) }
  scope :private_recipes, -> { where(public: false) }
end
