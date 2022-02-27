class RenameMenuRecipesTypeToKind < ActiveRecord::Migration[6.1]
  def change
    rename_column :menu_recipes, :type, :kind
  end
end
