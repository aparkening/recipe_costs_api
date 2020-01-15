class Ingredient < ApplicationRecord
  require 'csv'
  attr_accessor :total_cost

  # Relationships
  has_many :recipe_ingredients, dependent: :destroy
  has_many :recipes, through: :recipe_ingredients

  # Validations
  validates :name, presence: true, uniqueness: true
  validates :cost, presence: true, numericality: true
  validates :cost_size, presence: true, numericality: true
  validates :cost_unit, presence: true


  # Class import method for CSVs 
  def self.import(file)
    # Create hash by looping through each row
    CSV.foreach(file.path, headers: true) do |row|
      Ingredient.create! row.to_hash
    end
  end

  # Convert subset of ingredient units to Measured gem-compatible units
  def convert_to_measured
    converter = 1
    case self.cost_unit
      when "tsp"
        converter = 0.16667 # convert to us_fl_oz        
        self.cost_unit = "us_fl_oz"
      when "tbsp"
        converter = 0.5 # convert to us_fl_oz  
        self.cost_unit = "us_fl_oz"
      when "cup"
        converter = 8 # convert to us_fl_oz  
        self.cost_unit = "us_fl_oz"
    end
    self.cost_size *= converter
  end

end