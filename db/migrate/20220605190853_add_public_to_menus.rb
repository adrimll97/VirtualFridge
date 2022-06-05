class AddPublicToMenus < ActiveRecord::Migration[6.1]
  def change
    add_column :menus, :public, :boolean, null: false, default: false
  end
end
