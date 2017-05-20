Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    post 'events/' => 'events#receive', as: :receive
    post 'registration/' => 'team_registration#register', as: :register
  end

  resources :links
end
