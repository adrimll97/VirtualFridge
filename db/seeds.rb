# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

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
end
p 'Recetas creadas'

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
p 'Menus creados'
