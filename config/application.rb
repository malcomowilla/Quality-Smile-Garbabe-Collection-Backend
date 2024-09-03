require_relative "boot"

require "rails/all"
require_relative '../app/middleware/check_inactivity'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module QualitySmilesBackend
  class Application < Rails::Application
    # Sidekiq.strict_args!(false)
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1
    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w(assets tasks))
    config.middleware.use ActionDispatch::Cookies
    # rack attack middleware
    # # config/application.rb
config.middleware.use CheckInactivity
config.active_job.queue_adapter = :sidekiq

    config.middleware.use Rack::Attack
    config.autoload_paths += %W(#{config.root}/app/middleware)

    config.autoload_paths += %W(#{config.root}/app/services)
    config.autoload_paths << "#{root}app/lib"
    Dotenv::Railtie.load
    config.jwt_secret = ENV['JWT_SECRET']

    config.middleware.use ActionDispatch::Session::CookieStore, key: '__quality_smiles_session'
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    #
    #'Africa/Nairobi'
    #
    config.active_record.default_timezone = :local

    # config.active_record.default_timezone = :utc
    config.time_zone = 'Africa/Nairobi'
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
