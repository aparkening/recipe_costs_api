class Api::V1::RecipesController < ApplicationController
  # before_action :require_login

  # All records
  def index

    # Get search results or all recipes
    # Input format: http://localhost:3000/api/v1/recipes?search=ginger
    if params[:search]
      # If search, find results
      # recipes = Recipe.users_recipes(user).where('name LIKE ?', "%#{params[:search]}%").order('id DESC')
      recipes = Recipe.where('name ILIKE ?', "%#{params[:search]}%").order(name: :asc)
    else
      # Show everything
      recipes = Recipe.all.order(name: :asc)
    end

    # Map ingredient costs
    recipe_costs = recipes.map do |recipe|
      new_recipe = { recipe: {}}

      #  Set id, name, servings
      new_recipe[:recipe][:id] = recipe.id
      new_recipe[:recipe][:name] = recipe.name
      new_recipe[:recipe][:servings] = recipe.servings

      # Get costs per ingredient
      new_recipe_ingredients = recipe.recipe_ingredients.map { |ingredient| CombinedIngredient.new(ingredient) }

      # Calculate total cost
      new_recipe[:recipe][:total_cost] = recipe.calc_cost(new_recipe_ingredients)

      # Calculate cost per serving
      new_recipe[:recipe][:cost_per_serving] = recipe.calc_cost_per_serving(new_recipe[:recipe][:total_cost]) if recipe.servings

      # Add recipe_ingredients with costs
      new_recipe[:ingredients] = new_recipe_ingredients

      new_recipe
    end 

    # Render json
    render json: {recipes: recipe_costs}, status: 200  
  end

  # Display record
  def show
    recipe = Recipe.find_by(id: params[:id])
    
    # If recipe exists, iterate through ingredients to calculate each cost and combine into total cost and cost per serving.
    if recipe
      # Map costs for each ingredient
      recipe_ingredients = recipe.recipe_ingredients.map { |ingredient| CombinedIngredient.new(ingredient) }

      # Total recipe cost
      recipe_total_cost = recipe.calc_cost(recipe_ingredients)
      recipe[:total_cost] = recipe_total_cost

      # Cost per serving
      recipe[:cost_per_serving] = ''
      recipe[:cost_per_serving] = recipe.calc_cost_per_serving(recipe_total_cost) if recipe.servings

      # Render json
      render json: {recipe: recipe, ingredients: recipe_ingredients}, status: 200
    else
      not_found
    end
  end

  # Create record
  def create
    recipe = Recipe.new(recipe_params)
    if recipe.save
      # Map costs for each ingredient
      recipe_ingredients = recipe.recipe_ingredients.map { |ingredient| CombinedIngredient.new(ingredient) }

      # Total recipe cost
      recipe_total_cost = recipe.calc_cost(recipe_ingredients)
      recipe[:total_cost] = recipe_total_cost

      # Cost per serving
      recipe[:cost_per_serving] = ''
      recipe[:cost_per_serving] = recipe.calc_cost_per_serving(recipe_total_cost) if recipe.servings

      # Render json
      render json: {recipe: recipe, ingredients: recipe_ingredients}, status: 200
    else
      # render json: { message: 'Recipe creation error' }
      resource_error
    end
  end

  # Update record
  def update
    recipe = Recipe.find(params[:id])
    recipe.update(recipe_params)

    if recipe.save
      # Map costs for each ingredient
      recipe_ingredients = recipe.recipe_ingredients.map { |ingredient| CombinedIngredient.new(ingredient) }

      # Total recipe cost
      recipe_total_cost = recipe.calc_cost(recipe_ingredients)
      recipe[:total_cost] = recipe_total_cost

      # Cost per serving
      recipe[:cost_per_serving] = ''
      recipe[:cost_per_serving] = recipe.calc_cost_per_serving(recipe_total_cost) if recipe.servings

      # Render json
      render json: {recipe: recipe, ingredients: recipe_ingredients}, status: 200
    else
      # render json: { message: 'Recipe update error' }
      resource_error
    end
  end

  # Import CSVs
  # user_recipes_import_path
  def import
    # Recipe.import(params[:file], user)
    recipes_names = Recipe.import(params[:file])
    # recipes = Recipe.all

    # recipes = user.recipes
    # recipes = user.recipes.includes(:recipe_ingredients) 

    # render json: RecipeSerializer.new(recipes).serialized_json, status: 200

    # How to get latest added?
    render json: {recipeNames: recipes_names}, status: 200  
  end

  # Delete record
  def destroy
    recipe = Recipe.find(params[:id])
    
    # Manually delete recipe_ingredients, since dependent: :destroy isn't working.
    recipe.recipe_ingredients.each do |ri|
      ri.destroy
    end

    # Delete recipe
    recipe.destroy

    # Render json
    render json: {recipeId: recipe.id}, status: 200
  end

  # Display recipes by ingredient
  def by_ingredient
    # If ingredient exists, find recipes that use it
    if Ingredient.exists?(params[:id])
      ingredient = Ingredient.find(params[:id])
      recipes = Recipe.recipes_of_ingredient(params[:id])
    else
      recipes = Recipe.all
    end

    # Render json
    render json: {recipes: recipes}, status: 200  
  end

  private

  def recipe_params
    params.require(:recipe).permit(:name, :servings, recipe_ingredients_attributes: [:ingredient_id, :ingredient_amount, :ingredient_unit, :_destroy, :id])
  end

end
