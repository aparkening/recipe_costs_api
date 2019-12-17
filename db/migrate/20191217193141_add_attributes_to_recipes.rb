class AddAttributesToRecipes < ActiveRecord::Migration[6.0]
  def change
    add_column :recipes, :total_cost, :float
    add_column :recipes, :cost_per_serving, :float
  end
end
