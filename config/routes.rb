Rails.application.routes.draw do


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
