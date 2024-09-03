class CalendarEventsController < ApplicationController
  before_action :set_calendar_event, only: %i[ show edit update destroy ]


  load_and_authorize_resource
require 'rest-client'
require 'json'
require 'googleauth'
require 'onesignal'



  def index
    @calendar_events = CalendarEvent.all
    render json: @calendar_events
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
      # FcmNotificationJob.perform_now(@calendar_event.id, @fcm_token)
      notification_time = @calendar_event.start.in_time_zone - 30.minutes
      FcmNotificationJob.set(wait_until:notification_time).perform_later(@calendar_event.id, @fcm_token)
      # FcmNotificationJob.perform(@calendar_event.id)

      # FcmNotificationJob.perform_at(@calendar_event.start - 1.minute, @calendar_event.id)
      # Rails.logger.info 'Performed FCM after'
    else
      render json: @calendar_event.errors, status: :unprocessable_entity 
    end
  end
  

  def update
      if @calendar_event.update(calendar_event_params)
         render json: @calendar_event , status: :ok
      else
        render json: @calendar_event.errors, status: :unprocessable_entity 
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
