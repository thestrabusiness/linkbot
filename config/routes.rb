Rails.application.routes.draw do
  resources :links
  resources :dashboard, only: :index
  resources :sessions, only: [:new, :destroy]

  #Slack API redirects
  get 'sessions/create', to: 'sessions#create'
  get 'registration/' => 'registration#register', as: :register

  root to: 'dashboard#index'
end
