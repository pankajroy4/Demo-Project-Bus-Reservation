Rails.application.routes.draw do
  
  root "homes#index"
  
  devise_scope :user do
    get "/admin_login", to: "users/sessions#new"
  end
  
  get "admin_show/:id", to: "admins#show", as: :admin_show
  
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

  get "/bookings/:user_id", to: "reservations#booking", as: :bookings

  post "/get_resv_list", to: "buses#reservations_list", as: :get_resv_list

  delete "/reservations/:bus_id/:reservation_id/:id", to: "reservations#destroy", as: :cancel_ticket

  resources :buses do 
    resources :reservations, only: [:create, :index]
  end
  
  post "/searched_seat", to: "reservations#searched_seat", as: :searched
  post "/searched_bus", to: "homes#search", as: :search
 
  get "/get_list/:bus_id", to: "buses#get_list", as: :get_list

  get "/reservation_home/:bus_id", to: "reservations#reservation_home", as: :reservation_home
 
  # get 'approve/:bus_owner/bus/:id', to: "admins#approve", as: :approve 
  # get 'disapprove/:bus_owner/bus/:id', to: "admins#disapprove", as: :disapprove 

  post 'approve/:id', to: "admins#approve", as: :approve
  post 'disapprove/:id', to: "admins#disapprove", as: :disapprove

end
