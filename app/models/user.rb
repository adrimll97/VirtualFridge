# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :fridge, dependent: :destroy
  has_one :shopping_cart, dependent: :destroy
  has_one :weekly_planning, dependent: :destroy
  has_many :fridge_ingredients, through: :fridge
  has_many :shopping_cart_ingredients, through: :shopping_cart
  has_many :recipes, dependent: :destroy
  has_many :favorite_recipes, dependent: :destroy

  validates :name, presence: true
  validates :name, uniqueness: true

  def user_favorite_recipes
    Recipe.where(id: favorite_recipes.pluck(:recipe_id))
  end
end
