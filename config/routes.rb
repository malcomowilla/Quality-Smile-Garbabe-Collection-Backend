Rails.application.routes.draw do
  post '/update_customer_settings', to: 'general_settings#create_for_customer'
  get '/get_customer_settings', to: 'general_settings#get_settings_for_customer' 
post '/update_provider_settings', to: 'general_settings#create_for_provider'
get '/get_provider_settings', to: 'general_settings#get_settings_for_provider'

  resources :prefix_and_digits
  resources :service_providers
  resources :customers
  resources :stores
  resources :sub_locations
  resources :locations


  post '/signup-admin', to: 'admins#create'
  post '/login-admin', to: 'admins#login'
  delete '/logout-admin', to: 'admins#logout'

  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
