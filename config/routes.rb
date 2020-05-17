Rails.application.routes.draw do
  root 'static_pages#home'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :users do
    member do
      get :followers
      post :notices_check
      get :setting_form
      patch :setting
    end
  end

  resources :articles

  resources :likes, only: [:create, :destroy]

  resources :comments, only: [:show, :create, :destroy]

  resources :microposts

  resources :relationships, only: [:create, :destroy]

  get '/search', to: 'static_pages#search'
end
