Rails.application.routes.draw do
  root to: "bands#index"
  resources :users, only: [:new, :create] do
    collection do 
      get 'activate'
    end
  end
  resource :session, only: [:create, :new, :destroy]
  resources :bands do
    resources :albums, only: [:new]
  end
  
  resources :albums, except: [:index, :new] do
    resources :tracks, only: [:new]
  end

  resources :tracks, except: [:index, :new]
  
  resources :notes, only: [:create, :destroy]
end
