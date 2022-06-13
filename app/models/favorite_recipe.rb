# frozen_string_literal: true

class FavoriteRecipe < ApplicationRecord
  belongs_to :user
  belongs_to :recipe

  validates_presence_of :user, :recipe
  validates :favorite, inclusion: { in: [true, false] }
  validates :recipe, uniqueness: { scope: :user, message: 'ya es favorita del usuario' }

  scope :of_user, ->(user) { where(user_id: user&.id) }
  scope :of_recipe, ->(recipe) { where(recipe_id: recipe&.id) }

  after_update_commit :destroy_non_favorite_recipe

  def destroy_non_favorite_recipe
    destroy unless favorite
  end
end
