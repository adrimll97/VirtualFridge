# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_02_27_172730) do

  create_table "fridge_ingredients", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "fridge_id"
    t.bigint "ingredient_id"
    t.date "expiration_date"
    t.float "quantity_number", null: false
    t.string "quantity_unit", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["fridge_id", "ingredient_id"], name: "index_fridge_ingredients_on_fridge_id_and_ingredient_id", unique: true
    t.index ["fridge_id"], name: "index_fridge_ingredients_on_fridge_id"
    t.index ["ingredient_id"], name: "index_fridge_ingredients_on_ingredient_id"
  end

  create_table "fridges", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_fridges_on_user_id"
  end

  create_table "ingredients", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.text "url", null: false
    t.string "image_url"
    t.float "quantity_number", null: false
    t.string "quantity_unit", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "image"
  end

  create_table "menu_recipes", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "menu_id", null: false
    t.bigint "recipe_id", null: false
    t.integer "day", default: 0
    t.integer "kind", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["menu_id"], name: "index_menu_recipes_on_menu_id"
    t.index ["recipe_id"], name: "index_menu_recipes_on_recipe_id"
  end

  create_table "menus", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_menus_on_user_id"
  end

  create_table "recipe_ingredients", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "recipe_id", null: false
    t.bigint "ingredient_id", null: false
    t.float "quantity_number", null: false
    t.string "quantity_unit", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ingredient_id"], name: "index_recipe_ingredients_on_ingredient_id"
    t.index ["recipe_id", "ingredient_id"], name: "index_recipe_ingredients_on_recipe_id_and_ingredient_id", unique: true
    t.index ["recipe_id"], name: "index_recipe_ingredients_on_recipe_id"
  end

  create_table "recipes", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name", null: false
    t.string "image"
    t.text "steps"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_recipes_on_user_id"
  end

  create_table "shopping_cart_ingredients", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "shopping_cart_id"
    t.bigint "ingredient_id"
    t.float "quantity_number", null: false
    t.string "quantity_unit", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ingredient_id"], name: "index_shopping_cart_ingredients_on_ingredient_id"
    t.index ["shopping_cart_id", "ingredient_id"], name: "index_sci_on_shopping_cart_id_and_ingredient_id", unique: true
    t.index ["shopping_cart_id"], name: "index_shopping_cart_ingredients_on_shopping_cart_id"
  end

  create_table "shopping_carts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_shopping_carts_on_user_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "fridge_ingredients", "fridges"
  add_foreign_key "fridge_ingredients", "ingredients"
  add_foreign_key "fridges", "users"
  add_foreign_key "menu_recipes", "menus"
  add_foreign_key "menu_recipes", "recipes"
  add_foreign_key "menus", "users"
  add_foreign_key "recipe_ingredients", "ingredients"
  add_foreign_key "recipe_ingredients", "recipes"
  add_foreign_key "recipes", "users"
  add_foreign_key "shopping_cart_ingredients", "ingredients"
  add_foreign_key "shopping_cart_ingredients", "shopping_carts"
  add_foreign_key "shopping_carts", "users"
end
