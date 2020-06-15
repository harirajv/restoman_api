Rails.application.routes.draw do
  scope defaults: { format: :json } do

    scope :api  do
      resources :dishes, only: [:index, :show, :create, :update, :destroy]
      resources :users, only: [:index, :show, :create, :update]
      
      resources :orders, only: [:index, :show, :create, :update] do
        resources :order_items, only: [:index, :show, :create, :update]
      end
    end

    post '/login', to: 'authentication#login'
  end

  match '*path', to: 'application#routing_error', via: :all
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
