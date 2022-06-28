# frozen_string_literal: true

5.times do
  user = User.new
  user.name = Faker::Internet.username
  user.email = Faker::Internet.email(name: user.name, domain: 'example')
  user.password = '123456'
  user.save!
  fridge = Fridge.create(user_id: user.id)
  shopping_cart = ShoppingCart.create(user_id: user.id)

  Random.new.rand(10).times do
    ingredient = Ingredient.find(Ingredient.pluck(:id).sample)
    FridgeIngredient.create(fridge_id: fridge.id,
                            ingredient_id: ingredient.id,
                            quantity_number: ingredient.quantity_number,
                            quantity_unit: ingredient.quantity_unit)
  end

  Random.new.rand(10).times do
    ingredient = Ingredient.find(Ingredient.pluck(:id).sample)
    ShoppingCartIngredient.create(shopping_cart_id: shopping_cart.id,
                                  ingredient_id: ingredient.id,
                                  quantity_number: ingredient.quantity_number,
                                  quantity_unit: ingredient.quantity_unit)
  end
end
p 'Users created'

100.times do
  steps = []
  Random.new.rand(10).times do
    steps << Faker::Lorem.sentence(random_words_to_add: 30)
  end
  new_recipe = Recipe.create(user_id: User.all.pluck(:id).sample,
                             name: Faker::Food.dish,
                             steps: steps,
                             remote_image_url: Faker::LoremFlickr.image(size: '800x800', search_terms: %w[food dish lunch]),
                             public: Faker::Boolean.boolean)
  Random.new.rand(10).times do
    ingredient = Ingredient.find(Ingredient.pluck(:id).sample)
    RecipeIngredient.create(recipe_id: new_recipe.id,
                            ingredient_id: ingredient.id,
                            quantity_number: ingredient.quantity_number,
                            quantity_unit: ingredient.quantity_unit)
  end

  next unless Faker::Boolean.boolean(true_ratio: 0.3)

  fridge = Fridge.all.pluck(:id).sample
  new_recipe.recipe_ingredients.each do |recipe_ingredient|
    FridgeIngredient.create(fridge_id: fridge,
                            ingredient_id: recipe_ingredient.ingredient_id,
                            quantity_number: recipe_ingredient.quantity_number,
                            quantity_unit: recipe_ingredient.quantity_unit)
  end
end
p 'Recipes created'

50.times do
  new_menu = Menu.create(user_id: User.all.pluck(:id).sample,
                         name: Faker::Lorem.sentence(word_count: 2, random_words_to_add: 2),
                         description: Faker::Lorem.sentence(random_words_to_add: 30),
                         public: Faker::Boolean.boolean)
  7.times do |day|
    Random.new.rand(1..2).times do
      recipe = Recipe.public_recipes.find(Recipe.public_recipes.pluck(:id).sample)
      MenuRecipe.create(recipe_id: recipe.id, menu_id: new_menu.id, day: day, kind: 0)
    end
    Random.new.rand(1..2).times do
      recipe = Recipe.public_recipes.find(Recipe.public_recipes.pluck(:id).sample)
      MenuRecipe.create(recipe_id: recipe.id, menu_id: new_menu.id, day: day, kind: 1)
    end
  end
end
p 'Menus created'
