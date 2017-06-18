Rails.application.routes.draw do
  resources :links
  resources :homepage, only: :index
  resources :sessions, only: :new
  resource :sessions, only: :destroy, as: :session
  get 'sessions/add_account', to: 'sessions#edit', as: :add_account
  post 'sessions/update_active_team', to: 'sessions#update', as: :update_active_team

  #Slack API redirects
  get 'sessions/create', to: 'sessions#create'
  get 'registration/' => 'registration#register', as: :register
  get 'sessions/link', to: 'sessions#link', as: :link_account

  root to: 'homepage#index'
end
