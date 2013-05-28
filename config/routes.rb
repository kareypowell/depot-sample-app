Depot::Application.routes.draw do
  
  resources :line_items do
  	post 'decrement', on: :member
  	post 'increment', on: :member
  end

  resources :carts
  resources :products

  get "store/index"
  
  root 'store#index', as: 'store'
end
