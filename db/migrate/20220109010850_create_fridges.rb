class CreateFridges < ActiveRecord::Migration[6.1]
  def change
    create_table :fridges do |t|
      t.references :user, index: true, foreign_key: true

      t.timestamps
    end
  end
end
