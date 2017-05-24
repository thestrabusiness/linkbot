Rails.application.routes.draw do

  get 'registration/' => 'registration#register', as: :register
  get 'registration_success' => 'registration#sucess', as: :success
  resources :links
  resources :dashboard, only: :index

  root to: 'dashboard#index'
end
