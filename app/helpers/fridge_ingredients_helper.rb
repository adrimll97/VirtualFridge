# frozen_string_literal: true

module FridgeIngredientsHelper
  def expired_class(ingredient)
    return 'expired_ingredient' if ingredient.expired?
    return 'close_expired_ingredient' if ingredient.close_expired?

    ''
  end
end
