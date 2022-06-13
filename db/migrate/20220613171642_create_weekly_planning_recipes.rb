class CreateWeeklyPlanningRecipes < ActiveRecord::Migration[6.1]
  def change
    create_table :weekly_planning_recipes do |t|
      t.references :weekly_planning, index: true, foreign_key: true
      t.references :recipe, null: false, foreign_key: true
      t.integer :day, default: 0
      t.integer :type, default: 0

      t.timestamps
    end
  end
end
