require 'sidekiq/web'


Rails.application.routes.draw do
  resources :customer_wallet_payments
  resources :devices
  resources :customer_payments
  # resources :system_admins
  resources :sms_settings
  resources :contact_requests
  resources :accounts
  resources :finances_and_accounts
  mount ActionCable.server => '/cable'
  # mount Sidekiq::Web => '/sidekiq'



post '/create_theme_settings', to: 'theme_settings#create'
get '/get_theme_settings', to: 'theme_settings#get_theme_settings'




  
  get '/customers/stats', to: 'customer_stats#customer_stats'
  get '/service_providers/stats', to: 'service_provider_stats#service_provider_stats'
  post '/reset-password', to: 'password_resets#create'
  get '/app/stats', to: 'stats#app_stats'
  post '/invite_client', to: 'system_admins#invite_company_super_admins'
  get '/get_all_clients', to: 'accounts#index'

  post '/login_system_admin_email', to: 'system_admins#login_email'
  post '/login_system_admin_password', to: 'system_admins#login_email_password'
  post '/webauthn/register_system_admin', to: 'system_admins#register_webauthn_system_admin'
  post '/webauthn/create_register_system_admin', to: 'system_admins#create_webauthn_sys_admin'
  post '/webauthn/authenticate_register_system_admin', to: 'system_admins#authenticate_webauthn_system_admin'
  post '/webauthn/verify_register_system_admin', to: 'system_admins#verify_webauthn_sys_admin'
  get '/check_passkey_status', to: 'system_admins#check_passkey_status'
  get '/check_email_already_verified', to: 'system_admins#check_email_already_verified'
  get '/current_system_admin', to: 'system_admins#sys_admin'
  get '/get_system_admin_email_settings', to: 'system_admins#get_system_admin_email_settings'
  post '/create_system_admin_email_settings', to: 'system_admins#create_system_admin_email_settings'
  delete '/logout_system_admin', to: 'system_admins#logout_system_admin'
  

  get '/get_email_templates', to: 'email_templates#index'
  post '/email_template', to: 'email_templates#create'


  get '/service_provider_reports', to: 'service_provider_reports#index'
  get '/service_provider_reports/export', to: 'service_provider_reports#export'
  

  post '/create_sms_setting', to: 'sms_settings#create'
  get '/get_sms_settings', to: 'sms_settings#index'


  post '/company_settings', to: 'company_settings#create'
  get '/get_company_settings', to: 'company_settings#index'


  post '/email_settings', to: 'email_settings#create'
  get '/get_email_settings', to: 'email_settings#index'



  # resources :chat_rooms, only: [:show] do
  #   resources :chat_messages, only: [:create]
  # end


  # get '/current_chat', to: 'chat_rooms#current'
  post '/send_chat_message', to: 'chat_messages#create_chat_message'
  get '/chat_messages', to: 'chat_messages#get_chat_messages'
  get '/conversations', to: 'chat_messages#conversations'

# get '/allow_get_chat_messages', to: 'chat_messages#allow_get_chat_messages'
# post '/allow_send_chat_message', to: 'chat_messages#allow_create_chat_message'


  post '/update_customer_settings', to: 'general_settings#create_for_customer'
  get '/get_customer_settings', to: 'general_settings#get_settings_for_customer' 
  get '/allow_get_customer_settings', to: 'general_settings#allow_get_customer_settings'
  post '/update_provider_settings', to: 'general_settings#create_for_provider'
  get '/get_provider_settings', to: 'general_settings#get_settings_for_provider'
  get '/allow_get_settings_for_provider', to: 'general_settings#allow_get_settings_for_provider'
  post '/update_store_settings', to: 'general_settings#create_for_store'
  post '/update_store_manager', to: 'general_settings#create_for_store_manager'
  get '/get_store_manager', to: 'general_settings#get_settings_for_store_manager'
  get '/allow_get_settings_for_store_manager', to: 'general_settings#allow_get_settings_for_store_manager'
  post '/create_calendar_settings', to: 'general_settings#create_calendar_settings'
  get '/get_calendar_settings', to: 'general_settings#get_calendar_settings'


  get '/get_store_settings', to: 'general_settings#get_settings_for_store'
  post '/admin_settings', to: 'general_settings#create_admin_settings'
  get 'get_settings_for_admin', to: 'general_settings#get_admin_settings'
  get '/allow_get_admin_settings', to: 'general_settings#allow_get_admin_settings'
  post '/update_ticket_settings', to: 'general_settings#create_for_tickets'
  get '/get_ticket_settings', to: 'general_settings#get_settings_for_tickets'




  get '/upload_to_aws', to: 's3_uploaders#create'



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
  get '/all_sms', to: 'sms#get_all_sms'
  delete '/delete_sms/:id', to: 'sms#destroy'

  post '/create_sub_location', to: 'sub_locations#create'
  delete '/delete_sub_location/:id', to: 'sub_locations#destroy'
  get '/get_sub_locations', to: 'sub_locations#index'
  patch '/update_sub_location/:id', to: 'sub_locations#update'
  



  get '/address', to: 'reverse_geocoding#address'



  post '/create_store_manager', to: 'store_managers#create'
  delete '/delete_store_manager/:id', to: 'store_managers#destroy'
  get '/get_store_managers', to: 'store_managers#index'
  patch '/update_store_manager/:id', to: 'store_managers#update'
  post '/store_managers_login', to: 'store_managers#login'
  post '/verify_store_manager_otp', to: 'store_managers#verify_otp'
  post '/confirm_deivered_bags_from_store', to: 'store_managers#confirm_delivered'
  post '/confirm_bag_received_from_customer', to: 'store_managers#confirm_received'
  delete '/logout_store_manager', to: 'store_managers#logout'


  post '/create_location', to: 'locations#create'
  delete '/delete_location/:id', to: 'locations#destroy'
  get '/get_locations', to: 'locations#index'
  patch '/update_location/:id', to: 'locations#update'






  get '/total_customers', to: 'customers#total_customers'

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
  get '/my_current_customer', to: 'customers#my_current_customer'
  get '/get_current_customer', to: 'customers#get_current_customer'


  post '/confirm_collection', to: 'service_providers#confirm_collected'
  post '/confirm_delivery', to: 'service_providers#confirm_delivered'
  post '/otp_verify', to: 'service_providers#verify_otp'
  post '/service_provider_login', to: 'service_providers#login'
  delete '/logout_service_provider', to: 'service_providers#logout' 
  post '/create_service_provider', to: 'service_providers#create'
  get '/get_service_providers', to: 'service_providers#index'
  patch '/update_service_provider/:id', to: 'service_providers#update'
  delete '/delete_service_providers/:id', to: 'service_providers#destroy'
  get '/get_current_service_provider', to: 'service_providers#get_current_service_provider'
get '/total_service_providers', to: 'service_providers#total_service_providers'
post '/update_availability', to: 'service_providers#update_availability'
get '/get_current_status', to: 'service_providers#get_current_status'
get '/assign_service_provider', to: 'service_providers#my_current_service_provider'



  post '/invite_verify_with_webauth', to: 'user_registrations#create_webauthn'


  get '/get_calendar_events', to: 'calendar_events#index'
  get '/get_calendar_events_for_customer', to: 'calendar_events#allow_get_calendar_events_for_customer'
  post '/create_calendar_event', to: 'calendar_events#create'
  patch '/update_calendar_event/:id', to: 'calendar_events#update'
  delete '/delete_calendar_event/:id', to: 'calendar_events#destroy'
get '/total_calendar_events', to: 'calendar_events#total_calendar_events'


  post 'webauthn/register', to: 'admins#register_webauthn'
  post '/invite_register_with_webauth', to: 'admins#invite_register_with_webauthn'
  post 'webauthn/create', to: 'admins#create_webauthn'
  post 'webauthn/authenticate', to: 'admins#authenticate_webauthn'
  post 'webauthn/verify', to: 'admins#verify_webauthn'
  post '/signup-admin', to: 'admins#create'
  post '/login-admin', to: 'admins#login'
  delete '/logout-admin', to: 'admins#logout_admin'
  post '/otp-verification', to: 'admins#verify_otp'
  post '/password_forgotten', to: 'admins#forgot_password'
  post '/password_reset', to: 'admins#reset_password'
  post '/user_roles', to: 'admins#create_admins'
  delete '/delete_user_roles/:id', to: 'admins#delete_user'
  patch 'update_user_roles/:id', to: 'admins#update_user'
  patch '/update_admin', to: 'admins#update_admin'
  get '/get_admins', to: 'admins#index'
  get '/get_my_admins', to: 'admins#get_my_admins'
  get '/allow_get_updated_admin', to: 'admins#allow_get_updated_admin'
  get '/current_user', to: 'admins#user'
  post '/save_fcm_token', to: 'admins#create_fcm_token'
  get '/updated_admin', to: 'admins#user'
  post 'check_passkey_status', to: 'admins#check_passkey_status'
post '/lock_admin_account', to: 'admins#lock_admin_account'
post '/unlock_admin_account', to: 'admins#unlock_admin_account'
get '/total_users', to: 'admins#total_users'
post '/verify_device', to: 'admins#verify_device'


get '/total_tickets', to: 'support_tickets#total_tickets'
  get '/get_tickets', to: 'support_tickets#index'
  post '/create_ticket', to: 'support_tickets#create'
  patch '/update_ticket/:id', to: 'support_tickets#update'
  delete '/delete_ticket/:id', to: 'support_tickets#destroy'


get '/subscriptions/status', to: 'subscriptions#status'

post '/payments', to: 'payments#create'
get '/payments/payment_status/:id', to: 'payments#payment_status'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  post '/send_individual_email', to: 'emails#send_individual'

  # Defines the root path route ("/")
  # root "posts#index"
end
