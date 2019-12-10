Rails.application.routes.draw do

  mathjax 'mathjax'

  root 'static_pages#home'

  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'
  
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  resources :users

  resources :notes
  resources :notes do
    resources :memos,    only: [:new, :create, :edit, :update, :destroy]
    resources :pictures, only: [:new, :create, :edit, :update, :destroy]
  end

  resources :sites, only: [:edit, :update]

end
