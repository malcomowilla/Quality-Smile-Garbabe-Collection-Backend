class StatsController < ApplicationController

    ActsAsTenant.with_tenant(ActsAsTenant.current_tenant) do
      # Current tenant is set for all code in this block
    
  
    def app_stats
      begin
        # Get or set the login time in the session
        unless session[:login_time]
          session[:login_time] = Time.current
        end
        
        # Calculate time difference
        current_time = Time.current
        seconds_logged_in = (current_time - Time.parse(session[:login_time].to_s)).to_i
        
        # Convert to hours, minutes, seconds
        hours = seconds_logged_in / 3600
        minutes = (seconds_logged_in % 3600) / 60
        seconds = seconds_logged_in % 60
  
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
            total_seconds: seconds_logged_in,
            request_stats: request_stats
          }
        }
      rescue => e
        render json: {
          status: 'error',
          message: e.message
        }, status: :internal_server_error
      end
    end
  end
  end
  