Rails.application.routes.draw do


  get 'events', to: 'events#index'
  post 'events', to: 'events#create'
  get 'events/new', to: 'events#new', as: :new_event
  get 'events/:year', to: 'events#show'
  get 'events/:year/edit', to: 'events#edit', as: :edit_event
  patch 'events/:year', to: 'events#update', as: :event
  put 'events/:year', to: 'events#update'
  delete 'events/:year', to: 'events#destroy'
  
  get 'my_profile', to: 'profile#index'

  devise_for :users, controllers: {
    omniauth_callbacks:'users/omniauth_callbacks'
  }

  devise_scope :user do
    get 'sign_in', :to => 'devise/sessions#new', :as => :new_session
    delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_session
  end

  resources :countries

  root to: 'home#index'

end
