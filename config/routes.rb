Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'my_session' }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'home/index'
  root to: 'home#index'

  resources :ingredients, only: %i[index show] do
    get 'search', on: :collection
  end
end
