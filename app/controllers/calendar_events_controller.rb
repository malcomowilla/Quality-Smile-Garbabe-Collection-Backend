class CalendarEventsController < ApplicationController
  # before_action :set_calendar_event, only: %i[ show edit update destroy ]
  before_action :set_tenant 

  # set_current_tenant_through_filter
  load_and_authorize_resource except: [:allow_get_calendar_events_for_customer]
require 'rest-client'
require 'json'
require 'googleauth'
require 'onesignal'



def set_tenant
  @account = Account.find_by(subdomain: request.headers['X-Original-Host'])


  set_current_tenant(@account)
rescue ActiveRecord::RecordNotFound
  render json: { error: 'Invalid tenant' }, status: :not_found
end

   
# def set_tenant
#   random_name = "Tenant-#{SecureRandom.hex(4)}"
#   @account = Account.find_or_create_by(domain:request.domain, subdomain: request.subdomain, name: random_name)
  
#   set_current_tenant(current_user.account)
 
#  end

# def set_tenant
#   if current_user.present? && current_user.account.present?
#     set_current_tenant(current_user.account)
#   else
#     Rails.logger.debug "No tenant or current_user found"
#     # Optionally, handle cases where no tenant is set
#     raise ActsAsTenant::Errors::NoTenantSet
#   end
# end


  def index
    @calendar_events = CalendarEvent.all
    render json: @calendar_events
  end


  def allow_get_calendar_events_for_customer
    @calendar_events = CalendarEvent.all
    render json: @calendar_events

  end

  def total_calendar_events

    @total_calendar_events = CalendarEvent.count
    render json: { total_calendar_events: @total_calendar_events }, status: :ok if @total_calendar_events

  end

  def create
    @calendar_event = CalendarEvent.new(calendar_event_params)
  
    if @calendar_event.save
      render json: @calendar_event, status: :ok

      # ENV['ONE_SIGNAL_APP_ID']

      # OneSignal.configure do |config|
      #   # Configure Bearer authorization: app_key
      #   config.app_key = ENV['ONE_SIGNAL_API_KEY']
      # end
      
      # api_instance = OneSignal::DefaultApi.new
      # begin

      # notification = OneSignal::Notification.new({app_id: ENV['ONE_SIGNAL_APP_ID'] })
      # notification.contents = OneSignal::StringMap.new({'en': 'welcome to quality smiles'}) # Notification
      # notification.included_segments = ['Subscribed Users']
      # p notification
      #   # Create notification
      #   result = api_instance.create_notification(notification)
      #   p result
      # rescue OneSignal::ApiError => e
      #   puts "Error when calling DefaultApi->create_notification: #{e}"
      # end
      @fcm_token = current_user.fcm_token

      # start_in_minutes: params[:start_in_minutes],
      # start_in_hours: params[:start_in_hours]
      
      calendar_settings = MyCalendarSetting.first
      in_minutes = calendar_settings.start_in_minutes
      in_hours = calendar_settings.start_in_hours

      # FcmNotificationJob.perform_now(@calendar_event.id, @fcm_token)
      notification_time_minutes = @calendar_event.start.in_time_zone - in_minutes.to_i.minutes
      notification_time_hrs = @calendar_event.start.in_time_zone - in_hours.to_i.hours


      FcmNotificationJob.set(wait_until:notification_time_hrs).perform_later(@calendar_event.id, @fcm_token)
      FcmNotificationJob.set(wait_until:notification_time_minutes).perform_later(@calendar_event.id, @fcm_token)

      # FcmNotificationJob.perform(@calendar_event.id)

      # FcmNotificationJob.perform_at(@calendar_event.start - 1.minute, @calendar_event.id)
      # Rails.logger.info 'Performed FCM after'
    else
      render json: @calendar_event.errors, status: :unprocessable_entity 
    end
  end
  

  def update

    calendar_event = set_calendar_event
    
      if calendar_event.update(calendar_event_params)
        @fcm_token = current_user.fcm_token
        render json: calendar_event , status: :ok
        # start_in_minutes: params[:start_in_minutes],
        # start_in_hours: params[:start_in_hours]
        
        calendar_settings = MyCalendarSetting.first
        in_minutes = calendar_settings.start_in_minutes
        in_hours = calendar_settings.start_in_hours
#   Rails.logger.info "in_hours#{in_hours}"
# Rails.logger.info  "in_minutes#{in_minutes}"

        # FcmNotificationJob.perform_now(@calendar_event.id, @fcm_token)
        notification_time_minutes = calendar_event.start.in_time_zone - in_minutes.to_i.minutes
        notification_time_hrs = calendar_event.start.in_time_zone - in_hours.to_i.hours 

  
        FcmNotificationJob.set(wait_until:notification_time_hrs).perform_later(calendar_event.id, @fcm_token) if in_hours.present?
        FcmNotificationJob.set(wait_until:notification_time_minutes).perform_later(calendar_event.id, @fcm_token) if in_minutes.present?
         
      else
        render json: calendar_event.errors, status: :unprocessable_entity 
      end
    
  end

  # DELETE /calendar_events/1 or /calendar_events/1.json
  def destroy
    @calendar_event.destroy

       head :no_content 
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_calendar_event
      @calendar_event = CalendarEvent.find_by(id: params[:id])
    end

    # Only allow a list of trusted parameters through.
    def calendar_event_params
      params.require(:calendar_event).permit(:event_title, 
       :start, :end, :title)
    end
end
