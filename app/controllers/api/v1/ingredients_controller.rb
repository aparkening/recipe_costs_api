class Api::V1::IngredientsController < ApplicationController
  # before_action :require_admin, only: [:import, :create, :update, :destroy]

  # All records
  def index
    # Order ingredients alphabetically
    ingredients = Ingredient.all.order(name: :asc)

    # Check all valid units via Measured::Weight.unit_names
    render json: {ingredients: ingredients, units: available_units}, status: 200
  end

  # Create record
  def create
    # Make name lowercase
    params[:ingredient][:name] = params[:ingredient][:name].downcase

    ingredient = Ingredient.new(ing_params)
    if ingredient.save
      render json: {ingredient: ingredient}, status: 200
    else
      resource_error
    end
  end

  # Update record
  def update
    # Make name lowercase
    params[:ingredient][:name] = params[:ingredient][:name].downcase

    ingredient = Ingredient.find_by(id: params[:id])
    ingredient.update(ing_params)
    if ingredient.save
      render json: {ingredient: ingredient}, status: 200
    else
      resource_error
    end  
  end

  # Import CSVs
  def import
    Ingredient.import(params[:file])
    ingredients = Ingredient.all.order(name: :asc)

    ### How to render only newly imported items?
    render json: {ingredients: ingredients}, status: 200
    # render json: IngredientSerializer.new(ingredients).serialized_json, status: 200
  end

  # Delete record
  def destroy
    ingredient = Ingredient.find(params[:id])
    ingredient.destroy
    render json: {ingredientId: ingredient.id}, status: 200
  end

  private

  def ing_params
    params.require(:ingredient).permit(:name, :cost, :cost_size, :cost_unit)
  end
  
end
