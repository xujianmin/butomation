Rails.application.routes.draw do
  get "attendances/new"
  get "attendances/create"
  resources :users, only: [ :index, :show, :new, :create, :edit, :update ] do
    member do
      get :assign_virtual_users
      patch :assign_virtual_users, action: :assign_virtual_users_post
    end
  end

  resources :lotteries do
    member do
      get :statistics
    end
    resources :attendances, only: [ :new, :create ]
  end
  resource :session do
    member do
      post :heartbeat
    end
  end
  resources :passwords, param: :token

  resources :virtual_users do
    resources :pokermons, module: :sites do
      member do
        get :register
        get :login
        get :change_password
      end
    end
  end

  namespace :sites do
    resources :pokermons
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health_check#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "dashboard#home"
end
