Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'home/index'
  root to: 'home#index'

  resources :users, only: %i[show]
  resources :ingredients, only: %i[index show] do
    get 'search', on: :collection
    post 'create_user_ingredient', on: :member
  end
  resources :fridge_ingredients, only: %i[show update destroy]
  resources :shopping_cart_ingredients, only: %i[show update destroy] do
    post 'add_to_fridge', on: :member
  end
  resources :recipes do
    get 'search', on: :collection
    post 'change_privacity', on: :member
    post 'change_favority', on: :member
  end
  resources :menus do
    get 'search', on: :collection
    post 'change_privacity', on: :member
  end
  resources :weekly_planning, only: %i[index]
end
