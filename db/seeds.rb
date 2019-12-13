# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).


### Build seeds

# Recipes
white_bread = Recipe.create(name:"White Bread", servings:8)
english_muffins = Recipe.create(name:"English Muffins", servings:60)

choc_torte = Recipe.create(name:"Flourless Chocolate Torte", servings:64) 

puff_pastry = Recipe.create(name:"Puff Pastry", servings:92)
ginger_cake = Recipe.create(name:"Ginger Cake", servings:18)
 
chicken_teriyaki = Recipe.create(name:"Chicken Teriyaki", servings:4)
onigiri = Recipe.create(name:"Chicken Teriyaki Onigiri", servings:4)
tamagoyaki = Recipe.create(name:"Tamagoyaki", servings:4)

apple_cake = Recipe.create(name:"Apple Cake", servings:24)  

apple_pie = Recipe.create(name:"Apple Pie", servings:8) 
pumpkin_scones = Recipe.create(name:"Pumpkin Scones", servings:8) 

ginger_cookies = Recipe.create(name:"Ginger Cookies", servings:186) 

choc_chip_cookies = Recipe.create(name:"Chocolate Chip Cookies", servings:240)
macaroons = Recipe.create(name:"Macaroons", servings:60)

cinn_raisin_bread = Recipe.create(name:"Cinnamon Raisin Bread", servings:8) 
french_bread = Recipe.create(name:"French Bread", servings:6)
pizza_dough = Recipe.create(name:"Pizza Dough", servings:6)


# Ingredients
# -> Upload full set from app/assets/ingredients.csv

# Add ingredients to recipes
# -> Upload full set from recipe CSVs in app/assets


### Testing
# For each recipe, find_by_name, then loop through recipe ingredients to add each ingredient:
  # recipe.recipe_ingredients.create(ingredient:Ingredient.find_by_name("all-purpose flour"), ingredient_amount:6.376, ingredient_unit:"oz")

# Add ingredient to recipe
# r1_ing1 = user1_r1.recipe_ingredients.create(ingredient:ing1, ingredient_amount:6.376, ingredient_unit:"oz")
  # get name with user1_r1.recipe_ingredients.first.ingredient.name

# Make ingredient cost specific to user.
# user1_ing1 = user1.user_ingredient_costs.create(ingredient:ing1, cost:14.00, cost_size:1, cost_unit:"lb")

# Set CombinedIngredient object that combines data in Ingredient and UserIngredient
# combo_ing1 = CombinedIngredient.new(r1_ing1)
