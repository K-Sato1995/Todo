Rails.application.routes.draw do
  root 'tasks#index'
  resources :tasks
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :users
  namespace :admin do
    resources :users
  end
  get '*path', controller: 'application', action: 'render_404'
end
