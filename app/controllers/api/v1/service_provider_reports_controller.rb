module Api
  module V1
    class ServiceProviderReportsController < ApplicationController

    def index
      date_range = params[:date_range] || 'month'
      metric = params[:metric] || 'performance'
  
      # Calculate date range
      start_date = case date_range
                  when 'week' then 1.week.ago
                  when 'month' then 1.month.ago
                  when 'quarter' then 3.months.ago
                  when 'year' then 1.year.ago
                  end
  
      # Fetch and calculate statistics
      stats = calculate_stats(start_date)
      performance_data = calculate_performance_data(start_date)
      service_distribution = calculate_service_distribution(start_date)
  
      render json: {
        stats: stats,
        performanceData: performance_data,
        serviceDistribution: service_distribution
      }
    end
  
    def export
      # Handle report export logic
      # Generate CSV file with report data
      send_data generate_csv_report,
                filename: "service_provider_report_#{Time.current.strftime('%Y%m%d')}.csv",
                type: 'text/csv'
    end
  
    private
  
    def calculate_stats(start_date)
      total_providers = ServiceProvider.count
      previous_providers = ServiceProvider.where('created_at < ?', start_date).count
      provider_change = calculate_percentage_change(previous_providers, total_providers)
  
      average_rating = ServiceProvider.average(:rating).to_f
      previous_rating = ServiceProvider.where('created_at < ?', start_date).average(:rating).to_f
      rating_change = (average_rating - previous_rating).round(1)
  
      completion_rate = calculate_completion_rate
      previous_completion_rate = calculate_completion_rate(start_date)
      completion_change = calculate_percentage_change(previous_completion_rate, completion_rate)
  
      {
        total_providers: total_providers,
        average_rating: average_rating,
        completion_rate: completion_rate,
        provider_change: format_change(provider_change),
        rating_change: format_change(rating_change),
        completion_change: format_change(completion_change)
      }
    end
  
    def calculate_performance_data(start_date)
      # Group and calculate performance metrics by time period
      ServiceProvider.joins(:appointments)
                    .where('appointments.created_at >= ?', start_date)
                    .group("DATE_TRUNC('month', appointments.created_at)")
                    .select(
                      "DATE_TRUNC('month', appointments.created_at) as name",
                      'COUNT(CASE WHEN appointments.status = ? THEN 1 END) as completed',
                      'COUNT(CASE WHEN appointments.status = ? THEN 1 END) as cancelled'
                    )
                    .order('name')
    end
  
    def calculate_service_distribution(start_date)
      # Calculate service distribution statistics
      total = ServiceProvider.count
      on_time = ServiceProvider.joins(:appointments)
                             .where('appointments.status = ? AND appointments.created_at >= ?', 'completed', start_date)
                             .count
  
      [
        { name: 'On Time', value: on_time, color: '#22c55e' },
        { name: 'Late', value: (total * 0.1).round, color: '#eab308' },
        { name: 'Missed', value: (total * 0.05).round, color: '#ef4444' }
      ]
    end
  
    def calculate_percentage_change(old_value, new_value)
      return 0 if old_value.zero?
      ((new_value - old_value) / old_value.to_f * 100).round(1)
    end
  
    def format_change(value)
      value.positive? ? "+#{value}" : value.to_s
    end
  
    def calculate_completion_rate(date = nil)
      scope = ServiceProvider.joins(:appointments)
      scope = scope.where('appointments.created_at < ?', date) if date
      
      total = scope.count
      completed = scope.where(appointments: { status: 'completed' }).count
      
      return 0 if total.zero?
      ((completed.to_f / total) * 100).round(1)
    end

end
end
end