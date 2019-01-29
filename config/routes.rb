Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "pages#home"

  get "/home", to: "pages#home"
  get "/about", to: "pages#about"


  get '/login', to: "sessions#new"
  post '/login', to: "sessions#create"
  get '/logout', to: "sessions#destroy"

  get '/signup', to: "users#new"
  get '/newboard', to: "boards#new"
  resources :users, except: [:new]
  resources :boards, except: [:new]

end