# frozen_string_literal: true

class CreateMenuRecipes < ActiveRecord::Migration[6.1]
  def change
    create_table :menu_recipes do |t|
      t.references :menu, null: false, foreign_key: true
      t.references :recipe, null: false, foreign_key: true
      t.integer :day, default: 0
      t.integer :type, default: 0

      t.timestamps
    end
  end
end
