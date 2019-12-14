class RecipeIngredientSerializer
  include FastJsonapi::ObjectSerializer
  attributes :ingredient_amount, :ingredient_unit

  belongs_to :recipe
  belongs_to :ingredient
end
