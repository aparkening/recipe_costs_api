class ApplicationController < ActionController::API
  # include ActionController::Cookies
  # include ActionController::RequestForgeryProtection
  
  # protect_from_forgery with: :exception
  # before_action :set_csrf_cookie
  

  # Default index
  def index
    render json: { message: "Welcome Home!" }
  end


  ### Helpers
  # Set accepted ingredient units
  def available_units
    # # Get weight measurements
    # weight_units = Measured::Weight.unit_names
    
    # # Get volume measurements
    # volume_units = Measured::Volume.unit_names

    # # Combine both arrays
    # all_units = weight_units | volume_units

    # Too many extraneous units. Manual list easier.
    all_units = ['grams', 'kg', 'lb', 'oz', 'liters', 'gal', 'qt', 'pt', 'us_fl_oz', 'tsp', 'tbsp', 'cup', 'none', 'each'].sort
    return all_units
	end
  helper_method :available_units


  ### Errors
  # Render 404 message
  def not_found
    render json: { error: 'Resource not found'}, status: 404
  end

  # Render 400 message
  def resource_error
    render json: { error: 'Resource error. Please update request and try again.'}, status: 400
  end


  private

  # def set_csrf_cookie
  #   cookies['CSRF-TOKEN'] = form_authenticity_token
  # end


end
