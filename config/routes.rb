Rails.application.routes.draw do
  devise_for :users, {
    controllers: {
      sessions: 'devise/my_session',
      registrations: 'devise/my_registration',
      passwords: 'devise/my_passwords'
    }
  }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'home/index'
  root to: 'home#index'

  resources :ingredients, only: %i[index show] do
    get 'search', on: :collection
  end
end
