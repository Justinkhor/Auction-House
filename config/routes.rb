Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "home#index"
  get "/auth/:provider/callback" => "sessions#create_from_omniauth"
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'

  get '/signup' => 'users#new'
  post '/users' => 'users#create'
  resources :users
  resources :listings do
    resources :bids, only: [:create]
  end
  resources :images, only: [:destroy]
  resources :bids, except: [:create]
  get '/search', to: 'listings#search', as: 'search'
end
