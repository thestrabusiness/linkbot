Rails.application.routes.draw do
  namespace :api do
    post 'registration/' => 'registration#register', as: :register
  end

  resources :links
  resources :dashboard, only: :index

  root to: 'dashboard#index'
end
