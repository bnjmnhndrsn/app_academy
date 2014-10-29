Rails.application.routes.draw do
  root to: 'cats#index'
  resources :cats, only: [:show, :index, :new, :create, :update, :edit] do
    resources :cat_rental_requests, only: [:new, :create]
  end

  resources :cat_rental_requests, only: [:new, :create, :update]

end
