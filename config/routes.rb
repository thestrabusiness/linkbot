Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    post 'registration/' => 'registration#register', as: :register
  end

  resources :links
  resources :dashboard, only: :index
  resources :registration, only: :new

  root to: 'dashboard#index'
end
