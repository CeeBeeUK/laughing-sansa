Rails.application.routes.draw do
  get "ping", to: "status#ping", format: :json
  get "status", to: "status#ping", format: :json

  get 'my/:year/score/act/:act', to: 'my#score', as: 'my_scoring'
  patch 'my/:year/score/act/:act', to: 'my#score_create'

  get 'events/:year/admin', to: 'events#admin', as: 'game_admin'
  get 'events/:year/join', to: 'events#join', as: 'game_join'
  post 'events/:year/join', to: 'events#sign_up', as: 'game_sign_up'

  get 'events/:year/countries', to: 'participating_countries#manage', as: 'manage_countries'

  post 'participating_countries/:year/sort', to: 'participating_countries#sort', as: 'event_country'
  post 'participating_countries/:year/create',
       to: 'participating_countries#create',
       as: 'create_event_country'
  patch 'participating_countries/:year/allocate',
        to: 'participating_countries#allocate',
        as: 'allocate_country_player'

  resources :events, param: :year

  get 'users', to: 'users#index'
  get 'my/profile', to: 'my#profile'
  patch 'my/profile', to: 'my#profile_update'
  get 'my/:year/game', to: 'my#game', as: 'my_game'

  get 'kids/:year/game', to: 'kids#game', as: :kids_scoring_event
  get 'kids/:year/score/:act', to: 'kids#score_act', as: :kids_scoring_act
  patch 'kids/score/:eps', to: 'kids#create_score', as: :kids_scoring_create_score
  get 'kids/:year/join/:player', to: 'kids#join_game', as: :kids_join_game

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
