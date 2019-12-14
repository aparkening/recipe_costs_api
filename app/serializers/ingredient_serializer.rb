class IngredientSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :cost, :cost_size, :cost_unit, :updated_at
  has_many :recipe_ingredients, dependent: :destroy
  has_many :recipes, through: :recipe_ingredients
end
