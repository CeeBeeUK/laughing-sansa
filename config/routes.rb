Rails.application.routes.draw do

  get 'my/:year/score/act/:act', to: 'my#score', as: 'my_scoring'

  get 'events/:year/join', to: 'events#join', as: 'game_join'
  post 'events/:year/join', to: 'events#sign_up', as: 'game_sign_up'

  get 'events/:year/countries', to: 'participating_countries#manage', as: 'manage_countries'

  post 'participating_countries/:year/sort', to: 'participating_countries#sort', as: 'event_country'
  post 'participating_countries/:year/create',
    to: 'participating_countries#create',
    as: 'create_event_country'

  resources :events, param: :year

  get 'my/profile', to: 'my#profile'
  patch 'my/profile', to: 'my#profile_update'
  get 'my/:year/game', to: 'my#game', as: 'my_game'

  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  devise_scope :user do
    get 'sign_in', to: 'devise/sessions#new', as: :new_session
    delete 'sign_out', to: 'devise/sessions#destroy', as: :destroy_session
  end

  resources :countries, param: :name

  root to: 'home#index'

end
