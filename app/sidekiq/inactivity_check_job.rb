# class InactivityCheckJob
#   include Sidekiq::Job

#   def perform
#     #  Admin.where('last_activity_active < ?', 30.seconds.ago).update_all(inactive: true)
    
#     #  Admin.where('last_activity_active = ?', 30.seconds.ago).update_all(inactive: true)
#     #   # Use a more relaxed time comparison to account for minor differences in time precision
#     # time_threshold = 30.seconds.ago.in_time_zone('Africa/Nairobi')
#     now = Time.zone.now
    

#     @my_inactivity = AdminSettings.first
#     inactivity_hrs = @my_inactivity.check_inactive_hrs
#     inactivity_days = @my_inactivity.check_inactive_days
#     inactivity_minutes = @my_inactivity.check_inactive_minutes
#       # time_threshold_hrs =  60.minutes.ago
#       # time_threshold_days =  3.days.ago
#       # time_threshold_hrs = Time.zone.now.advance(hours: -inactivity_hrs) if inactivity_hrs.present?
#     time_threshold_days = inactivity_days.to_i.days.ago if inactivity_days.present?
#     time_threshold_hrs = inactivity_hrs.to_i.hours.ago if inactivity_hrs.present?
#     time_threshold_minutes = inactivity_minutes.to_i.minutes.ago if inactivity_minutes.present?

# #  t.boolean "enable_inactivity_check_minutes"
# #     t.boolean "enable_inactivity_check_hours"
#     # time_threshold =  now.ago(30.seconds)
#     # Rails.logger.info "Checking for inactive admins at: #{Time.now.in_time_zone('Africa/Nairobi')}"
#     # Rails.logger.info "Threshold time for inactivity: #{time_threshold_hrs}"
#     Rails.logger.info "Threshold time for inactivity minutes: #{time_threshold_minutes}"

#  Rails.logger.info "Threshold time for inactivity hrs: #{time_threshold_hrs}"
#  Rails.logger.info "Threshold time for inactivity days: #{time_threshold_days}"
#     # all_admins = Admin.all.pluck(:id, :last_activity_active)
#     # all_admins.each do |id, last_activity|
#     #   Rails.logger.info "Admin ID: #{id}, Last Activity: #{last_activity}"
#     # end
#     admins_to_update_hrs = Admin.where('last_activity_active < ?', time_threshold_hrs)
#     admins_to_update_minutes = Admin.where('last_activity_active < ?', time_threshold_minutes)
#     admins_to_update_days = Admin.where('last_activity_active < ?', time_threshold_days)


#     # admins_to_update = admins_to_update.or(Admin.where('last_activity_active < ?', time_threshold_days)) if time_threshold_days.present?
#     # admins_to_update = Admin.where('last_activity_active = ?',  time_threshold_hrs, time_threshold_days )
#     # Rails.logger.info "Admins to be marked as inactive: #{admins_to_update.pluck(:id)}"

#     admins_to_update_minutes.update_all(inactive: true)
#     admins_to_update_hrs.update_all(inactive: true)
#     admins_to_update_days.update_all(inactive: true)
  
#   end
# end




class InactivityCheckJob
  include Sidekiq::Job

  def perform
    Account.find_each do |account|
      begin
        ActsAsTenant.with_tenant(account) do
          Rails.logger.info "Starting inactivity check for account - Domain: #{account.domain}, Subdomain: #{account.subdomain}"
          
          @my_inactivity = AdminSettings.first
          next unless @my_inactivity # Skip if no settings found

          process_inactivity_checks
        end
      rescue => e
        Rails.logger.error "Error processing account #{account.domain}: #{e.message}"
        Rails.logger.error e.backtrace.join("\n")
      end
    end
  end

  private

  def process_inactivity_checks
    # Check minutes if minutes value is present
    if @my_inactivity.check_inactive_minutes.present? && @my_inactivity.check_inactive_minutes.to_i > 0
      process_minutes_check
    end

    # Check hours if hours value is present
    if @my_inactivity.check_inactive_hrs.present? && @my_inactivity.check_inactive_hrs.to_i > 0
      process_hours_check
    end

    # Check days if days value is present
    if @my_inactivity.check_inactive_days.present? && @my_inactivity.check_inactive_days.to_i > 0
      process_days_check
    end
  end

  def process_minutes_check
    threshold = @my_inactivity.check_inactive_minutes.to_i.minutes.ago
    Rails.logger.info "Processing minutes check with threshold: #{threshold}"
    mark_inactive(threshold)
  end

  def process_hours_check
    threshold = @my_inactivity.check_inactive_hrs.to_i.hours.ago
    Rails.logger.info "Processing hours check with threshold: #{threshold}"
    mark_inactive(threshold)
  end

  def process_days_check
    threshold = @my_inactivity.check_inactive_days.to_i.days.ago
    Rails.logger.info "Processing days check with threshold: #{threshold}"
    mark_inactive(threshold)
  end

  def mark_inactive(threshold)
    admins_affected = Admin.where('last_activity_active < ?', threshold)
                          .where(inactive: false)
                          .update_all(inactive: true)
    
    Rails.logger.info "Marked #{admins_affected} admins as inactive (threshold: #{threshold})"
  end
end


