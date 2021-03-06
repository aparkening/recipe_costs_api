class CombinedIngredient
  attr_reader :name, :amount, :amount_unit, :total_cost, :ingredient, :base_cost_unit, :base_cost_size, :base_cost, :cost_ratio, :id

  ### Constants for conversion not included in Measured gem
  TSP = 0.16667 #fl_oz
  TBSP = 0.5 # fl_oz
  CUP = 8 # fl_oz
  EA = 1 # individual amount
  # A cup of all-purpose flour weighs 4 1/4 ounces or 120 grams

  
  ### Build object that combines amounts, units, and costs from ingredients and user_ingredient_costs tables
  # Then calculate ingredient cost for recipe
  def initialize(recipe_ingredient)
    # @user = recipe_ingredient.recipe.user
    @id = recipe_ingredient.id
    @ingredient = recipe_ingredient.ingredient
    @name = @ingredient.name
    @amount = recipe_ingredient.ingredient_amount
    @amount_unit = recipe_ingredient.ingredient_unit
    
    @total_cost, @cost_ratio, @base_cost, @base_cost_size, @base_cost_unit = 0, 0, 0, 0, ""

    # Get specific ingredients for costs
    self.set_ingredients

    # Calculate costs
    self.calc_costs
  end


  # Look for ingredients in UserIngredient first, then Ingredient
  def set_ingredients
    # Look for ingredient in user_ingredient_costs table
    # user_details = @user.user_ingredient_costs.find_by(ingredient: @ingredient)

    # if user_details
    #   # If ingredient in user_ingredient_costs table, grab cost, cost size, and cost unit
    #   @base_cost = user_details.cost
    #   @base_cost_size = user_details.cost_size
    #   @base_cost_unit = user_details.cost_unit
    # else
      # Else grab cost, cost size, and cost unit from main ingredients table
      ingredient = Ingredient.find_by(id: @ingredient.id)
      @base_cost = ingredient.cost
      @base_cost_size = ingredient.cost_size
      @base_cost_unit = ingredient.cost_unit
    # end
  end


  # Convert amounts between volume and weight
  # Use universal conversion constant for now: 1 kg == 1 L water
  def convert_vol_weight(convert_to)
    # Convert current weight to kilograms, then return as liter amount
    if convert_to == "volume"
      kilo_amount =  Measured::Weight.new(@amount, @amount_unit).convert_to(:kg).value.to_f    
      converted = Measured::Volume.new(kilo_amount, :l).convert_to(@base_cost_unit).value.to_f   

    # Convert current volume to liters, then return as kilo amount
    else 
      liter_amount =  Measured::Volume.new(@amount, @amount_unit).convert_to(:l).value.to_f    
      converted = Measured::Weight.new(liter_amount, :kg).convert_to(@base_cost_unit).value.to_f  
    end
    return converted
  end


  # Use volume or weight for conversion
  def convert_amount(type)
    if type == "volume"
      # If base_cost_unit is weight, convert amount and amount_unit to weight
      if Measured::Weight.unit_or_alias?(@base_cost_unit)
        converted_amount = convert_vol_weight("weight")
      else 
        # Else calculate using volume
        converted_amount = Measured::Volume.new(@amount, @amount_unit).convert_to(@base_cost_unit).value.to_f          
      end
    else
      # If base_cost_unit is volume, convert amount and amount_unit to volume
      if Measured::Volume.unit_or_alias?(@base_cost_unit)
        converted_amount = convert_vol_weight("volume")
      else 
        # Else convert using weight
        converted_amount = Measured::Weight.new(@amount, @amount_unit).convert_to(@base_cost_unit).value.to_f          
      end
    end
    return converted_amount 
  end


  # Calculate base and total costs
  def calc_costs

    # Calculate base cost by dividing cost by size
    @cost_ratio = @base_cost.to_f / @base_cost_size

    # If @amount_unit == @base_cos_unit, no conversion needed. Multiply amount by base_cost
    if @amount_unit == @base_cost_unit || @amount_unit == "none" || @amount_unit == "each"
      @total_cost = (@cost_ratio * @amount).round(2)
  
    # Else convert units to calculate total cost
    else

      # Check all valid units: Measured::Weight.unit_names

      # If amount_unit in Measured Weight database, convert
      if Measured::Weight.unit_or_alias?(@amount_unit)
        # Convert amount based on weight or volume
        converted_amount = convert_amount("weight")

      # If amount_unit in Measured Volume database, convert
      elsif Measured::Volume.unit_or_alias?(@amount_unit)
        # Convert amount based on weight or volume
        converted_amount = convert_amount("volume")
     
      # Else convert by constants
      else 
        # Save initial values. Display after calculations made.
        saved_amount = @amount
        saved_unit = @amount_unit

        case @amount_unit
        when "tsp"
          @amount *= TSP
        when "tbsp"
          @amount *= TBSP
        when "cup"
          @amount *= CUP
        end

        # Reset amount_unit to oz
        @amount_unit = "us_fl_oz"

        # Convert amount based on weight or volume
        converted_amount = convert_amount("volume")

        @amount = saved_amount
        @amount_unit = saved_unit
      end

      @total_cost = (@cost_ratio * converted_amount).round(2)
    end
  end

end