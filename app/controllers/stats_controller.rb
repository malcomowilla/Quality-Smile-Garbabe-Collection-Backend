class StatsController < ApplicationController

  ActsAsTenant.with_tenant(ActsAsTenant.current_tenant) do
    # Current tenant is set for all code in this block

  def app_stats
    begin
      @current_user = current_user
      current_time = Time.current
      
      # Find or create today's work session
      work_session = WorkSession.today.for_admin(@current_user.id).first

      if work_session.nil?
        # Create new session if none exists
        work_session = WorkSession.create!(
          admin_id: @current_user.id,
          date: Date.current,
          started_at: current_time,
          last_active_at: current_time,
          total_time_seconds: 0
        )
      else
        # Update existing session
        if work_session.started_at.nil?
          work_session.update!(started_at: work_session.created_at || current_time)
        end
        
        # Update last_active_at if enough time has passed
        if work_session.last_active_at.nil? || current_time - work_session.last_active_at > 5.seconds
          work_session.update!(last_active_at: current_time)
        end
      end

      # Calculate total working time for today
      total_seconds = calculate_working_time(work_session)
      
      # Convert to hours, minutes, seconds
      hours = total_seconds / 3600
      minutes = (total_seconds % 3600) / 60
      seconds = total_seconds % 60

      # Get customer request statistics
      total_requests = Customer.sum(:total_requests)
      total_confirmations = Customer.sum(:total_confirmations)
      request_stats = {
        total_requests: total_requests,
        total_confirmations: total_confirmations,
        confirmation_rate: total_requests > 0 ? (total_confirmations.to_f / total_requests * 100).round(2) : 0
      }
      
      render json: {
        status: 'success',
        data: {
          hours: hours,
          minutes: minutes,
          seconds: seconds,
          total_seconds: total_seconds,
          request_stats: request_stats,
          session_start: work_session.started_at,
          last_active: work_session.last_active_at,
          debug_info: {
            session_id: work_session.id,
            created_at: work_session.created_at
          }
        }
      }
    rescue => e
      render json: {
        status: 'error',
        message: e.message,
        backtrace: e.backtrace
      }, status: :internal_server_error
    end
  end

  private

  def calculate_working_time(work_session)
    return 0 unless work_session.started_at && work_session.last_active_at

    inactivity_threshold = 30.minutes
    current_time = Time.current
    
    # Base time is from start to last activity
    total_time = (work_session.last_active_at - work_session.started_at).to_i
    
    # Add time since last activity if within threshold
    time_since_last_activity = current_time - work_session.last_active_at
    if time_since_last_activity <= inactivity_threshold
      total_time += time_since_last_activity.to_i
    end

    # Don't let total time exceed time since session start
    max_possible_time = (current_time - work_session.started_at).to_i
    total_time = [total_time, max_possible_time].min
    
    # Store the accumulated time
    work_session.update_column(:total_time_seconds, total_time)
    
    total_time
  end

end
end
