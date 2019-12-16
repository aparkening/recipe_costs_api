Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  # Root
  root 'application#index'

  namespace :api do
    namespace :v1 do
      # Ingredients
      resources :ingredients, only: [:index, :create, :update, :destroy]
      post 'ingredients/import'

      # Recipes
      resources :recipes, only: [:index, :create, :update, :destroy]
      get 'recipes/ingredients/:id' => 'recipes#by_ingredient', as: "recipes_by_ingredient"
      post 'recipes/import'
    end
  end


end
