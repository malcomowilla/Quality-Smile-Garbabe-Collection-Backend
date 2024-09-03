class InactivityCheckJob
  include Sidekiq::Job

  def perform
    #  Admin.where('last_activity_active < ?', 30.seconds.ago).update_all(inactive: true)
    
    #  Admin.where('last_activity_active = ?', 30.seconds.ago).update_all(inactive: true)
    #   # Use a more relaxed time comparison to account for minor differences in time precision
    # time_threshold = 30.seconds.ago.in_time_zone('Africa/Nairobi')
    now = Time.zone.now
    

    @my_inactivity = AdminSettings.first
    inactivity_hrs = @my_inactivity.check_inactive_hrs
    inactivity_days = @my_inactivity.check_inactive_days
    inactivity_minutes = @my_inactivity.check_inactive_minutes
      # time_threshold_hrs =  60.minutes.ago
      # time_threshold_days =  3.days.ago
      # time_threshold_hrs = Time.zone.now.advance(hours: -inactivity_hrs) if inactivity_hrs.present?
    time_threshold_days = inactivity_days.to_i.days.ago if inactivity_days.present?
    time_threshold_hrs = inactivity_hrs.to_i.hours.ago if inactivity_hrs.present?
    time_threshold_minutes = inactivity_minutes.to_i.minutes.ago if inactivity_minutes.present?

#  t.boolean "enable_inactivity_check_minutes"
#     t.boolean "enable_inactivity_check_hours"
    # time_threshold =  now.ago(30.seconds)
    # Rails.logger.info "Checking for inactive admins at: #{Time.now.in_time_zone('Africa/Nairobi')}"
    # Rails.logger.info "Threshold time for inactivity: #{time_threshold_hrs}"
    Rails.logger.info "Threshold time for inactivity minutes: #{time_threshold_minutes}"

 Rails.logger.info "Threshold time for inactivity hrs: #{time_threshold_hrs}"
 Rails.logger.info "Threshold time for inactivity days: #{time_threshold_days}"
    # all_admins = Admin.all.pluck(:id, :last_activity_active)
    # all_admins.each do |id, last_activity|
    #   Rails.logger.info "Admin ID: #{id}, Last Activity: #{last_activity}"
    # end
    admins_to_update_hrs = Admin.where('last_activity_active < ?', time_threshold_hrs)
    admins_to_update_minutes = Admin.where('last_activity_active < ?', time_threshold_minutes)
    admins_to_update_days = Admin.where('last_activity_active < ?', time_threshold_days)


    # admins_to_update = admins_to_update.or(Admin.where('last_activity_active < ?', time_threshold_days)) if time_threshold_days.present?
    # admins_to_update = Admin.where('last_activity_active = ?',  time_threshold_hrs, time_threshold_days )
    # Rails.logger.info "Admins to be marked as inactive: #{admins_to_update.pluck(:id)}"

    admins_to_update_minutes.update_all(inactive: true)
    admins_to_update_hrs.update_all(inactive: true)
    admins_to_update_days.update_all(inactive: true)
  
  end
end










