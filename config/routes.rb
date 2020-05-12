Rails.application.routes.draw do
  devise_for :users
  scope :api do
    resources :orders
    resources :dishes
    resources :users
  end

  post 'auth_user' => 'authentication#authenticate_user'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
