Rails.application.routes.draw do
  root 'static_pages#home'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :users do
    member do
      get :followers
    end
  end

  resources :articles

  resources :likes, only: [:create, :destroy]

  resources :comments, only: [:create, :destroy] 

  resources :microposts

  resources :relationships, only: [:create, :destroy]
end
