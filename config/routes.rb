Rails.application.routes.draw do
  resources :links
  resources :homepage, only: :index
  resources :sessions, only: :new
  resource :sessions, only: :destroy, as: :session

  #Slack API redirects
  get 'sessions/create', to: 'sessions#create'
  get 'registration/' => 'registration#register', as: :register

  root to: 'homepage#index'
end
