Rails.application.routes.draw do

  get 'registration/' => 'registration#register', as: :register
  get 'registration/success' => 'registration#success', as: :success
  resources :links
  resources :dashboard, only: :index

  root to: 'dashboard#index'
end
