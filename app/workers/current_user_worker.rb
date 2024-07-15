
class CurrentUserWorker
  include Sidekiq::Worker

  def perform(*args)
    logger.info "Things are happening #{args.inspect}."
    logger.debug { "My args: #{args.inspect}" }
    # puts "customer#{user_id}"
    # user = Admin.find(user_id)
    # if user
    #   # puts "Running periodic task at #{Time.now}"
    #   # puts "Running periodic task at #{user.user_name}"
    #   # CurrentUserChannel.broadcast_to(user, { user: user.user_name })
    # else
    #   puts "Admin with ID #{user_id} not found."
    # end
  end
end