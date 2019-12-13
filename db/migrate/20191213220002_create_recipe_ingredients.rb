class CreateRecipeIngredients < ActiveRecord::Migration[6.0]
  def change
    create_table :recipe_ingredients do |t|
      t.belongs_to :recipe, index: true, null: false, foreign_key: true
      t.belongs_to :ingredient, index: true, null: false, foreign_key: true
      t.float :ingredient_amount
      t.string :ingredient_unit

      t.timestamps
    end
  end
end
