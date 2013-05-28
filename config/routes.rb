Depot::Application.routes.draw do
  
  resources :orders

  resources :line_items do
  	post :decrement, on: :member
  	post :increment, on: :member
  end

  resources :carts

  resources :products do
  	get :who_bought, on: :member
  end
  
  root 'store#index', as: 'store'
end
