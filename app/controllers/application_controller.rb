class ApplicationController < ActionController::API
  # include ActionController::Cookies
  # include ActionController::RequestForgeryProtection
  
  # protect_from_forgery with: :exception
  # before_action :set_csrf_cookie
  

  # Default index
  def index
    render json: { message: "Welcome Home!" }
  end


  ### Errors

  # Render 404 message
  def not_found
    reunder json: { message: 'Resource not found'}, status: 404
  end

  # Render 409 message
  def conflict
    reunder json: { message: 'Resource conflict. Please update and try again.'}, status: 409
  end


  private

  # def set_csrf_cookie
  #   cookies['CSRF-TOKEN'] = form_authenticity_token
  # end


end
