require 'sidekiq/web'

Rails.application.routes.draw do
  
  root "homes#index"
  get "admin_show/:id", to: "admins#show", as: :admin_show
  
  devise_scope :user do
    get "/admin_login", to: "users/sessions#new"

    get  "/otp_verification", to: "users/confirmations#otp_verification", as: :verify 
  
    patch "/verification", to: "users/sessions#otp_verification", as: :verify_login 
    patch "/resend_otp", to: "users/sessions#resend_otp", as: :resend_otp
  end

  devise_scope :bus_owner do 
    get  "/otp_verification/busowner", to: "bus_owners/confirmations#otp_verification", as: :verify_busowner 
   
    patch "/verification/busowner" , to: "bus_owners/sessions#otp_verification", as: :verify_login_busowner 
    patch "/resend_otp/busowner", to: "bus_owners/sessions#resend_otp", as: :resend_otp_busowner
  end
  
  devise_for :users, controllers: {
    registrations: 'users/registrations', 
    sessions: "users/sessions",
    passwords: "users/passwords",
    confirmations: "users/confirmations"
  }
  
  devise_for :bus_owners, class_name: "User", controllers: { 
    registrations: "bus_owners/registrations", 
    sessions: "bus_owners/sessions",
    passwords: "bus_owners/passwords",
    confirmations: "bus_owners/confirmations" 
  }
  
  resources :users, only: [:show, :index]
  
  resources :bus_owners do 
    resources :buses
  end
  
  get "/new_ticket/:bus_id", to: "reservations#new", as: :new_ticket
  resources :buses do 
    resources :reservations, only: [:create, :index]
  end

  get "/searched_bus", to: "homes#search", as: :search
  get "/bookings/:user_id", to: "reservations#booking", as: :bookings
  get "/get_resv_list/:bus_id", to: "buses#reservations_list", as: :get_resv_list
  delete "/reservations/:bus_id/:reservation_id/:id", to: "reservations#destroy", as: :cancel_ticket
  patch 'approve/:bus_owner_id/:id', to: "admins#approve", as: :approve
  patch 'disapprove/:bus_owner_id/:id', to: "admins#disapprove", as: :disapprove

  authenticate :user do
    mount Sidekiq::Web => '/sidekiq'
  end
  
  # Myapp::Application.routes.draw do
  #   # mount Sidekiq::Web in your Rails app
  # mount Sidekiq::Web => "/sidekiq"
  # end

end
