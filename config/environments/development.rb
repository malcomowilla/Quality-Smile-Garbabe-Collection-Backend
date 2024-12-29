require "active_support/core_ext/integer/time"
Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded any time
  # it changes. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.

  Rails.application.routes.default_url_options[:host] = 'localhost:4000'
  # Rails.application.routes.default_url_options[:host] = 'https://74jp5ccr-5173.uks1.devtunnels.ms/'
  config.action_cable.url = "ws://localhost:4000/cable"
  config.action_mailer.default_url_options = { host: 'http://localhost:4000' }


  # config.action_dispatch.trusted_proxies = [
  #   '127.0.0.1',
  #   '::1',
  #   /192\.168\.\d+\.\d+/,
  #   /10\.\d+\.\d+\.\d+/, # Add any private IP ranges used by your proxy
  #   /172\.(1[6-9]|2[0-9]|3[0-1])\.\d+\.\d+/ # Private IPs in 172.16.0.0/12 range
  # ]




  # MAIL_TRAP_USERNAME = api
  # MAIL_TRAP_DOMAIN = aitechsent.net
  # MAIL_TRAP_PASSWORD = f17620673c51e537ef268dea49025da8
  

  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true


  # config.action_mailer.delivery_method = :smtp
#   config.action_mailer.mailtrap_settings
#   config.action_mailer.delivery_method = :mailtrap
#   # config.action_mailer.raise_delivery_errors = true
#   # 
  
#   config.action_mailer.mailtrap_settings= {
#   # :user_name => ENV['MAIL_TRAP_USERNAME'],
#   # :password => ENV['MAIL_TRAP_PASSWORD'],
#   # :address => 'live.smtp.mailtrap.io',
#   # :domain => 'aitechsent.net',
#   # :port => '587',
#   # :authentication => :plain,

#   # :enable_starttls_auto => true   
#   api_key: 'f17620673c51e537ef268dea49025da8',
# }

# # config/environments/development.rb
# Rails.application.config.to_prepare do
#   EmailSettingsConfigurator.configure
# end


  config.enable_reloading = true
  # config.action_mailer.perform_deliveries = true
  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable server timing
  config.server_timing = true

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Rails.root.join("tmp/caching-dev.txt").exist?
    config.action_controller.perform_caching = false
    config.action_controller.enable_fragment_cache_logging = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      "Cache-Control" => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end
  config.active_job.queue_adapter = :sidekiq

  # Add this configuration
config.action_mailer.asset_host = 'http://localhost:4000'
config.active_storage.service_url_host = 'http://localhost:4000'

  # Store uploaded files on the local file system (see config/storage.yml for options).
  config.active_storage.service = :local

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise exceptions for disallowed deprecations.
  config.active_support.disallowed_deprecation = :raise

  # Tell Active Support which deprecation messages to disallow.
  config.active_support.disallowed_deprecation_warnings = []

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true

  # Highlight code that enqueued background job in logs.
  config.active_job.verbose_enqueue_logs = true

  # Suppress logger output for asset requests.
  # config.assets.quiet = true
# config.active_job.queue_adapter = :sidekiq
  # Raises error for missing translations.
  # config.i18n.raise_on_missing_translations = true
  # Annotate rendered view with file names.
  # config.action_view.annotate_rendered_view_with_filenames = true
# config.hosts << "c5b2-102-68-79-197.ngrok-free.app"
  # Uncomment if you wish to allow Action Cable access from any origin.
  config.action_cable.disable_request_forgery_protection = true
  config.action_cable.allowed_request_origins = [
    'http://localhost:5173',
    'http://localhost:3000',
  ]

  # Raise error when a before_action's only/except options reference missing actions
  config.action_controller.raise_on_missing_callback_actions = true
end
