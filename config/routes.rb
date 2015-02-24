Rails.application.routes.draw do

  get "games/score/:id", to: 'games#score'

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
