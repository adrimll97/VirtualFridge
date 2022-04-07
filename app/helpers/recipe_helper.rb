# frozen_string_literal: true

module RecipeHelper
  def self_recipe?(recipe)
    recipe.user_id == current_user&.id
  end
end
