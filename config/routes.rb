Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      namespace :merchants do
        get '/find_all', to: 'search#index'
        get '/find', to: 'search#show'
      end
      
      namespace :items do
        get '/find_all', to: 'search#index'
        get '/find', to: 'search#show'
      end

      resources :merchants, only: [ :index, :show ] do
        resources :items, only: [ :index ], controller: 'merchants/items'
      end

      resources :items, only: [ :index, :show, :create, :update, :destroy ]  do
        resources :merchant, only: [ :index ], controller: 'items/merchant'
      end
    end
  end
end
