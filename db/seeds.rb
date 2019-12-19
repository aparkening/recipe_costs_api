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
flour = Ingredient.create(name: "all-purpose flour", cost: 20.49, cost_size: 50, cost_unit: "lb")
b_flour = Ingredient.create(name: "bread flour", cost: 18.49, cost_size: 50, cost_unit: "lb")
w_flour = Ingredient.create(name: "whole wheat flour", cost: 21.43, cost_size: 50, cost_unit: "lb")
butter = Ingredient.create(name: "butter", cost: 107.02, cost_size: 36, cost_unit: "lb")
sugar = Ingredient.create(name: "sugar", cost: 23.06, cost_size: 50, cost_unit: "lb")
molasses = Ingredient.create(name: "molasses", cost: 26.74, cost_size:56.8, cost_unit: "lb")
v_extract = Ingredient.create(name: "vanilla extract", cost: 32.46, cost_size: 16, cost_unit: "oz")
egg = Ingredient.create(name: "egg", cost: 0.25, cost_size: 1, cost_unit: "each")
salt = Ingredient.create(name: "salt", cost: 18.13, cost_size: 25, cost_unit: "lb")
choc_chips = Ingredient.create(name: "chocolate chips", cost: 15.35, cost_size: 5, cost_unit: "lb")
b_soda = Ingredient.create(name: "baking soda", cost: 24.84, cost_size:50, cost_unit: "lb")
walnuts = Ingredient.create(name: "walnuts", cost: 98.75, cost_size:25, cost_unit: "lb")


# Add ingredients to recipes
# -> Upload full set from recipe CSVs in app/assets
cc_butter = choc_chip_cookies.recipe_ingredients.create(ingredient:Ingredient.find_by_name("butter"), ingredient_amount:2, ingredient_unit:"lb")
cc_sugar = choc_chip_cookies.recipe_ingredients.create(ingredient:Ingredient.find_by_name("sugar"), ingredient_amount:35, ingredient_unit:"oz")
cc_molasses = choc_chip_cookies.recipe_ingredients.create(ingredient:Ingredient.find_by_name("molasses"), ingredient_amount:1.42, ingredient_unit:"oz")
cc_v_extract = choc_chip_cookies.recipe_ingredients.create(ingredient:Ingredient.find_by_name("vanilla extract"), ingredient_amount:0.5, ingredient_unit:"oz")
cc_v_egg = choc_chip_cookies.recipe_ingredients.create(ingredient:Ingredient.find_by_name("egg"), ingredient_amount:8, ingredient_unit:"none")
cc_flour = choc_chip_cookies.recipe_ingredients.create(ingredient:Ingredient.find_by_name("all-purpose flour"), ingredient_amount:2.5, ingredient_unit:"lb")
cc_b_soda = choc_chip_cookies.recipe_ingredients.create(ingredient:Ingredient.find_by_name("baking soda"), ingredient_amount:0.9, ingredient_unit:"oz")
cc_salt = choc_chip_cookies.recipe_ingredients.create(ingredient:Ingredient.find_by_name("salt"), ingredient_amount:0.75, ingredient_unit:"oz")
cc_choc_chips = choc_chip_cookies.recipe_ingredients.create(ingredient:Ingredient.find_by_name("chocolate chips"), ingredient_amount:36, ingredient_unit:"oz")
cc_walnuts = choc_chip_cookies.recipe_ingredients.create(ingredient:Ingredient.find_by_name("walnuts"), ingredient_amount:8, ingredient_unit:"oz")

# choc_chop_flour = user1_r1.recipe_ingredients.create(ingredient:ing1, ingredient_amount:6.376, ingredient_unit:"oz")
  # get name with user1_r1.recipe_ingredients.first.ingredient.name


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
