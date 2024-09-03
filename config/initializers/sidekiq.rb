Sidekiq.configure_server do |config|

  config.redis = { url: 'redis://localhost:6379/0' }
  config.redis = { url: 'redis://localhost:6379/0' }
  config.on(:startup) do



    Sidekiq.schedule = {
     

'inactivity_check_job' => {
        'class' => 'InactivityCheckJob',
        'cron' => "*/3 * * * * *", # Runs every 3 hours

      },
      
      # 'generate_web_authn_options_job' => {
      #   'class' => 'GenerateWebAuthnOptionsJob',
      #   'concurrency' => 5,
      #   'queues' => 'default'

      # }


    }
    Sidekiq::Scheduler.reload_schedule!
    # Sidekiq.strict_args!(false)

    # InactivityCheckJob
  end
end


Sidekiq.configure_client do |config|
  # Enable strict aSidekiq.logger.formatter = Sidekiq::Logger::Formatters::JSON.new
  
  Sidekiq.strict_args!(false)
end

# require 'sidekiq/scheduler'

# Sidekiq.configure_server do |config|
#   config.on(:startup) do
#     Sidekiq.schedule = YAML.load_file(File.expand_path('../../sidekiq_schedule.yml', __FILE__))
#     Sidekiq::Scheduler.reload_schedule!
#   end
# end
# 

