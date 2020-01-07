class Api::V1::RecipesController < ApplicationController
  # before_action :require_login

  # All records
  def index
    recipes = Recipe.all.order(name: :asc)
    
# Want to display:
#  Ginger Cookies	$5.97  |  per serving: $0.03	Edit | Delete

  #   if is_admin?
  #     @recipes = Recipe.all
  #     @user = User.find_by(id: params[:user_id])

  #     # Admin search matches all recipes
  #     if params[:search]
  #       # If search, find results
	# 	    @recipes = Recipe.where('name LIKE ?', "%#{params[:search]}%").order('id DESC')
  #     end
  #   else
  #     redirect_non_users     
  
  
      # user = User.find_by(id: params[:user_id])
      # user = current_user

      # Input format: http://localhost:3000/api/v1/recipes?search=ginger
      if params[:search]
        # If search, find results
        # recipes = Recipe.users_recipes(user).where('name LIKE ?', "%#{params[:search]}%").order('id DESC')
        recipes = Recipe.where('name ILIKE ?', "%#{params[:search]}%").order('id DESC')
      else
        # Show everything
        # recipes = user.recipes.includes(:recipe_ingredients) 
      end

      # Map ingredient costs
      recipe_costs = recipes.map do |recipe|
        new_recipe = { recipe: {}}

        new_recipe[:recipe][:id] = recipe.id
        # new_recipe[:user_id] = recipe.user_id
        new_recipe[:recipe][:name] = recipe.name
        new_recipe[:recipe][:servings] = recipe.servings

        # Get costs per ingredient
        new_recipe_ingredients = recipe.recipe_ingredients.map { |ingredient| CombinedIngredient.new(ingredient) }

        # Calculate total cost
        # cost << recipe.total_cost(recipe_ingredients)
        new_recipe[:recipe][:total_cost] = recipe.calc_cost(new_recipe_ingredients)

        # Calculate cost per serving
        # cost << recipe.cost_per_serving(recipe.total_cost(recipe_ingredients)) if recipe.servings
        new_recipe[:recipe][:cost_per_serving] = recipe.calc_cost_per_serving(new_recipe[:recipe][:total_cost]) if recipe.servings

        new_recipe[:ingredients] = new_recipe_ingredients

        new_recipe
      end 

	    # options = {
	    #   include: [:recipe_ingredients]
	    # }
      # render json: RecipeSerializer.new(recipes, options).serialized_json, status: 200  

      render json: {recipes: recipe_costs}, status: 200  
  end

  # Display record
  def show
    # redirect_non_users
    # user = User.find_by(id: params[:user_id])
  
    # Require authorization
    # require_authorization(@user)

    # Search all recipes for admin; subset for user
    # if is_admin?
    #   @recipe = Recipe.find_by(id: params[:id])
    # else 
      # recipe = user.recipes.find_by(id: params[:id])
      recipe = Recipe.find_by(id: params[:id])
    # end

    # If recipe exists, iterate through ingredients to calculate each cost and combine into total cost and cost per serving.
    if recipe
      # authorize_owner_resource(recipe)

      # Map costs for each ingredient
      recipe_ingredients = recipe.recipe_ingredients.map { |ingredient| CombinedIngredient.new(ingredient) }

      # Total recipe cost
      recipe_total_cost = recipe.calc_cost(recipe_ingredients)
      recipe[:total_cost] = recipe_total_cost

      # Cost per serving
      recipe[:cost_per_serving] = ''
      recipe[:cost_per_serving] = recipe.calc_cost_per_serving(recipe_total_cost) if recipe.servings


	    # options = {
      #   # include: [:recipe_ingredients]
      #   include: recipe_ingredients
	    # }
      # render json: RecipeSerializer.new(recipe, options).serialized_json, status: 200 

      # render json: {recipe: recipe, totalCost: recipe_total_cost, costPerServing: recipe_cost_per_serving, recipeIngredients: recipe_ingredients}, status: 200

      render json: {recipe: recipe, ingredients: recipe_ingredients}, status: 200
      
      # If don't want to show other attributes
      # render json: recipe, except: [:created_at, :updated_at]


    else
      # render json: { message: 'Recipe not found' }
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

      # JSON output
      render json: {recipe: recipe, ingredients: recipe_ingredients}, status: 200
    else
      # render json: { message: 'Recipe creation error' }
      resource_error
    end
  end

  # Update record
  def update
    # redirect_non_users
    # user = User.find_by(id: params[:user_id])
    
    # Require authorization
    # require_authorization(@user)

binding.pry

    recipe = Recipe.find(params[:id])
    recipe.update(recipe_params)

    if recipe.save
      # render json: RecipeSerializer.new(recipe).serialized_json, status: 200
      render json: {recipe: recipe}, status: 200  

    # {recipe: recipe, totalCost: recipe_total_cost, costPerServing: recipe_cost_per_serving, recipeIngredients: recipe_ingredients}


    else
      # render json: { message: 'Recipe update error' }
      resource_error
    end
  end

  # Import CSVs
  # user_recipes_import_path
  def import
    # redirect_non_users
    
    # user = User.find_by(id: params[:user_id])

    # require_authorization(user)

    # Recipe.import(params[:file], user)
    recipes_names = Recipe.import(params[:file])
    # recipes = Recipe.all

    # recipes = user.recipes
    # recipes = user.recipes.includes(:recipe_ingredients) 

    # render json: RecipeSerializer.new(recipes).serialized_json, status: 200



    # How to get latested added?

    render json: {recipeNames: recipes_names}, status: 200  
  end

  # Delete record
  def destroy
    # redirect_non_users
    # user = User.find_by(id: params[:user_id])

    # Require authorization
    # require_authorization(user)

    recipe = Recipe.find(params[:id])
    
    # Manually delete recipe_ingredients, since dependent: :destroy isn't working.
    recipe.recipe_ingredients.each do |ri|
      ri.destroy
    end

    recipe.destroy

    render json: {recipeId: recipe.id}, status: 200
  end

  # Display recipes by ingredient
  def by_ingredient
    # redirect_non_users
        
    # user = User.find_by(id: params[:user_id])
  
    # If ingredient exists, find recipes that use it
    if Ingredient.exists?(params[:id])
      ingredient = Ingredient.find(params[:id])
      # if is_admin?
      #   # Show all recipes from ingredient for admins
      #   @recipes = Recipe.recipes_of_ingredient(params[:id])
      # else
        # Only show user's recipes
        # recipes = user.recipes.recipes_of_ingredient(params[:id])
        recipes = Recipe.recipes_of_ingredient(params[:id])
      # end
    else
      # flash[:alert] = "That ingredient wasn't found."
      # Else show all users' recipes
      recipes = Recipe.all
    end

    # render json: RecipeSerializer.new(recipes).serialized_json, status: 200
    render json: {recipes: recipes}, status: 200  
  end

  private

  # def find_user
  #   @user = User.find_by(id: params[:user_id])
  # end

  def recipe_params
    params.require(:recipe).permit(:name, :servings, recipe_ingredients_attributes: [:ingredient_id, :ingredient_amount, :ingredient_unit, :_destroy, :id])
  end


end
