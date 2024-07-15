

Rails.application.routes.draw do
  resources :sms_templates
  resources :finances_and_accounts
  mount ActionCable.server => '/cable'
  post '/update_customer_settings', to: 'general_settings#create_for_customer'
  get '/get_customer_settings', to: 'general_settings#get_settings_for_customer' 
post '/update_provider_settings', to: 'general_settings#create_for_provider'
get '/get_provider_settings', to: 'general_settings#get_settings_for_provider'
post '/update_store_settings', to: 'general_settings#create_for_store'
post '/update_store_manager', to: 'general_settings#create_for_store_manager'
get '/get_store_manager', to: 'general_settings#get_settings_for_store_manager'
get '/get_store_settings', to: 'general_settings#get_settings_for_store'
post '/admin_settings', to: 'general_settings#create_admin_settings'
get 'get_settings_for_admin', to: 'general_settings#get_admin_settings'




post '/save_sms_template', to: 'sms_templates#create'
get '/get_sms_templates', to: 'sms_templates#index'




get '/stores', to: 'stores#index'
post '/create_store', to: 'stores#create'
patch '/update_store', to: 'stores#update'
delete '/delete_store/:id', to: 'stores#destroy'

get '/make_mpesa_payment', to: 'payments#make_mpesa_payment'
get '/confirmation', to: 'payments#confirm'
get '/validation', to: 'payments#validate'






get '/your_sms_balance', to: 'sms#get_sms_balance'
post '/sms_status_message', to: 'sms#status_message'
get '/all_sms', to: 'sms#index'


  post '/create_sub_location', to: 'sub_locations#create'
  delete '/delete_sub_location/:id', to: 'sub_locations#destroy'
  get '/get_sub_locations', to: 'sub_locations#index'
  patch '/update_sub_location/:id', to: 'sub_locations#update'
  



  get '/address', to: 'reverse_geocoding#address'



  post '/create_store_manager', to: 'store_managers#create'
  delete '/delete_store_manager/:id', to: 'store_managers#destroy'
  get '/get_store_managers', to: 'store_managers#index'
  patch '/update_store_manager/:id', to: 'store_managers#update'
 delete '/logout_store_manager', to: 'store_managers#logout' 
 post '/store_managers_login', to: 'store_managers#login'
 post '/verify_store_manager_otp', to: 'store_managers#verify_otp'






post '/create_location', to: 'locations#create'
delete '/delete_location/:id', to: 'locations#destroy'
get '/get_locations', to: 'locations#index'
patch '/update_location/:id', to: 'locations#update'







 delete '/logout_customer', to: 'customers#logout' 
post '/customer_login', to: 'customers#login'
  post '/customer', to: 'customers#create'
get '/customers', to: 'customers#index'
patch 'update_customer/:id', to: 'customers#update'
delete 'delete_customer/:id', to: 'customers#destroy'
get '/get_customer_code', to: 'customers#get_customer_code' 
post '/otp_verification', to: 'customers#verify_otp'
post '/confirm_bag', to: 'customers#confirm_bag'
post '/confirm_request', to: 'customers#confirm_request'
 



post '/confirm_collection', to: 'service_providers#confirm_collected'
post '/confirm_delivery', to: 'service_providers#confirm_delivered'
post '/otp_verify', to: 'service_providers#verify_otp'
post '/service_provider_login', to: 'service_providers#login'
delete '/logout_service_provider', to: 'service_providers#logout' 
post '/create_service_provider', to: 'service_providers#create'
get '/get_service_providers', to: 'service_providers#index'
patch '/update_service_provider/:id', to: 'service_providers#update'
delete '/delete_service_providers/:id', to: 'service_providers#destroy'





  post '/signup-admin', to: 'admins#create'
  post '/login-admin', to: 'admins#login'
  delete '/logout-admin', to: 'admins#logout'
  post '/otp-verification', to: 'admins#verify_otp'
  post '/password_forgotten', to: 'admins#forgot_password'
  post '/password_reset', to: 'admins#reset_password'
  post '/user_roles', to: 'admins#create_admins'
  delete '/delete_user_roles/:id', to: 'admins#delete_user'
  patch 'update_user_roles/:id', to: 'admins#update_user'
  patch 'update_admin', to: 'admins#update_admin'
  get '/get_admins', to: 'admins#index'
  get '/current_user', to: 'admins#user'
   
  

  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
