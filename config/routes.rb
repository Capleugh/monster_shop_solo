Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "/", to: "welcome#index"

  resources :merchants do
    resources :items, only: [:index, :new, :create]
  end

  resources :items, only: [:index, :show, :edit, :update, :destroy] do
    resources :reviews, only: [:new, :create]
  end

  resources :reviews, only: [:edit, :update, :destroy]

  resources :orders, only: [:new, :show, :update]

  namespace :merchant, as: :merchant_user  do
    get '/', to: 'dashboard#show'

    resources :orders, only: [:show, :update]
    resources :items
    resources :coupons
  end

  namespace :admin, as: :admin do
    get '/', to: 'dashboard#index'

    resources :users, only: [:index, :show] do
      resources :orders, only: [:show, :destroy]
    end

    resources :merchants, only: [:index, :show, :update] do
      resources :items, only: [:index, :new, :create, :edit, :update, :destroy]
    end
  end

  get "/users/register", to: "users#new"
  post "/users", to: "users#create"


  get "/profile", to: "users#show"
  get "/profile/edit", to: "users#edit"
  patch "/profile", to: "users#update"

  delete "/profile/orders/:order_id", to: "orders#destroy"
  get '/profile/orders', to: 'orders#index'
  post "/profile/orders", to: "orders#create"
  get "/profile/orders/:order_id", to: "orders#show"

  get "/cart", to: "cart#show"
  post "/cart/apply", to: "cart#add_coupon"
  post "/cart/:item_id", to: "cart#add_item"
  patch "/cart/:item_id", to: "cart#update"
  delete "/cart", to: "cart#empty"
  delete "/cart/:item_id", to: "cart#remove_item"

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
end
