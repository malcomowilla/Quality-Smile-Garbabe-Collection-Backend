Sidekiq.configure_server do |config|
  config.on(:startup) do
    Sidekiq.schedule = {
      'current_user_worker' => {
        'class' => 'CurrentUserWorker',
        'cron' => '*/8 * * * * *' ,
      }
    }
    Sidekiq::Scheduler.reload_schedule!
    Sidekiq.strict_args!(false)


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
