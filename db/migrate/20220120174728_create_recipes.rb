class CreateRecipes < ActiveRecord::Migration[6.1]
  def change
    create_table :recipes do |t|
      t.references :user, index: true, foreign_key: true
      t.string :name, null: false
      t.string :image
      t.text :steps

      t.timestamps
    end
  end
end
