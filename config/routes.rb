Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  root 'sessions#new'
  
  get 'dashboard', to: 'dashboard#index'
  get 'universities', to: 'dashboard#unis'
  get 'admins', to: 'dashboard#admins'
  get 'students', to: 'dashboard#students'
  get 'events', to: 'dashboard#events'

  get 'overview', to: 'overview#index'
  
  get '/error', to: 'sessions#error'
  post '/', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  get '/new/user', to: 'sessions#newUser'
  post '/new/user', to: 'users#create'
  get '/new/admin', to: 'dashboard#newAdmin'
  post '/new/admin', to: 'dashboard#createAdmin'

  get '/edit/admin', to: 'dashboard#editAdmin'
  post '/edit/admin', to: 'dashboard#updateAdmin'

  get '/user', to: 'dashboard#viewUser'
  delete '/user', to: 'dashboard#destroyUser'

  get '/landing', to: 'sessions#landing'

  resources :password_resets, only: [:new, :create, :edit, :update]
end
