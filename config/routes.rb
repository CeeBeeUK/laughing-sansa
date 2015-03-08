Rails.application.routes.draw do

  get 'events/:year/join', to: 'participating_player#new', as:'new_join_game'
  post 'events/:year/join', to: 'participating_player#create', as:'create_join_game'

  get "games/score/:id", to: 'games#score', as: 'test_score'

  resources :events, param: :year

  get 'my_profile', to: 'profile#show'
  patch 'my_profile', to: 'profile#update'
  devise_for :users, controllers: {
    omniauth_callbacks:'users/omniauth_callbacks'
  }

  devise_scope :user do
    get 'sign_in', :to => 'devise/sessions#new', :as => :new_session
    delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_session
  end

  resources :countries, param: :name

  root to: 'home#index'

end
