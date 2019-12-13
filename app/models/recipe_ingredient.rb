class RecipeIngredient < ApplicationRecord
  belongs_to :recipe
  belongs_to :ingredient

  # Validations
  validates :ingredient_amount, presence: true, numericality: true
  validates :ingredient_unit, presence: true  
end
