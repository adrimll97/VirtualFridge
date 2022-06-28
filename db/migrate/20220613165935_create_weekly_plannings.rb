class CreateWeeklyPlannings < ActiveRecord::Migration[6.1]
  def change
    create_table :weekly_plannings do |t|
      t.references :user, index: true, foreign_key: true

      t.timestamps
    end
  end
end
