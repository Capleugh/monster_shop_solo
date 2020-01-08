Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "/", to: "welcome#index"

  get "/merchants", to: "merchants#index"
  get "/merchants/new", to: "merchants#new"
  get "/merchants/:id", to: "merchants#show"
  post "/merchants", to: "merchants#create"
  get "/merchants/:id/edit", to: "merchants#edit"
  patch "/merchants/:id", to: "merchants#update"
  delete "/merchants/:id", to: "merchants#destroy"

  get "/items", to: "items#index"
  get "/items/:id", to: "items#show"
  get "/items/:id/edit", to: "items#edit"
  patch "/items/:id", to: "items#update"
  get "/merchants/:merchant_id/items", to: "items#index"
  get "/merchants/:merchant_id/items/new", to: "items#new"
  post "/merchants/:merchant_id/items", to: "items#create"
  delete "/items/:id", to: "items#destroy"

  get "/items/:item_id/reviews/new", to: "reviews#new"
  post "/items/:item_id/reviews", to: "reviews#create"

  get "/reviews/:id/edit", to: "reviews#edit"
  patch "/reviews/:id", to: "reviews#update"
  delete "/reviews/:id", to: "reviews#destroy"

  get "/cart", to: "cart#show"
  post "/cart/:item_id", to: "cart#add_item"
  patch "/cart/:item_id", to: "cart#update"
  delete "/cart", to: "cart#empty"
  delete "/cart/:item_id", to: "cart#remove_item"

  delete "/profile/orders/:order_id", to: "orders#destroy"
  get "/orders/new", to: "orders#new"
  get "/orders/:id", to: "orders#show"
  patch '/orders/update/:id', to: 'orders#update'

  delete "/profile/orders/:order_id", to: "orders#destroy"
  get '/profile/orders', to: 'orders#index'
  post "/profile/orders", to: "orders#create"
  get "/profile/orders/:order_id", to: "orders#show"

  get "/users/register", to: "users#new"
  post "/users", to: "users#create"
  get "/profile", to: "users#show"
  get "/profile/edit", to: "users#edit"
  patch "/profile", to: "users#update"


  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  namespace :merchant  do
    get '/', to: 'dashboard#show'
    resources :orders, only: [:show, :update]
    resources :items, only: [:index, :show, :update, :destroy, :new, :create]
  end

  namespace :admin do
    get '/', to: 'dashboard#index'
    resources :users, only: [:index, :show]
    resources :merchants, only: [:index, :show, :update] do
      resources :items, only: [:index, :new, :create]
    end
  end
end
