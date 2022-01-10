Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'home/index'
  root to: 'home#index'

  resources :users, only: %i[show]
  resources :ingredients, only: %i[index show] do
    get 'search', on: :collection
  end
  resources :fridge_ingredients, only: %i[create]
end
