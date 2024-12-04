
class ServiceProviderReportsController < ApplicationController

# before_action :set_tenant 

# def set_tenant
#   @account = Account.find_or_create_by(subdomain: request.headers['X-Original-Host'])

#   set_current_tenant(@account)
# rescue ActiveRecord::RecordNotFound
#   render json: { error: 'Invalid tenant' }, status: :not_found
# end

def index
  begin
    date_range = params[:date_range] || 'month'
    metric = params[:metric] || 'performance'

    start_date = case date_range
                when 'week' then 1.week.ago
                when 'month' then 1.month.ago
                when 'quarter' then 3.months.ago
                when 'year' then 1.year.ago
                end

    service_providers = current_tenant.service_providers

    render json: {
      stats: calculate_stats(service_providers, start_date),
      performanceData: calculate_performance_data(service_providers, start_date),
      serviceDistribution: calculate_service_distribution(service_providers, start_date)
    }, status: :ok
  rescue StandardError => e
    Rails.logger.error("Report generation error: #{e.message}\n#{e.backtrace.join("\n")}")
    render json: { error: 'Error generating report' }, status: :internal_server_error
  end
end

private

def calculate_percentage_change(old_value, new_value)
  return 0 if old_value.to_f.zero?
  ((new_value.to_f - old_value.to_f) / old_value.to_f * 100).round(1)
end



def calculate_stats(providers, start_date)
  total_providers = providers.count
  previous_providers = providers.where('service_providers.created_at < ?', start_date).count
  provider_change = calculate_percentage_change(previous_providers, total_providers)

  average_rating = providers.average(:rating).to_f.round(1) || 0.0
  previous_rating = providers
    .where('service_providers.created_at < ?', start_date)
    .average(:rating).to_f.round(1) || 0.0
  rating_change = (average_rating - previous_rating).round(1)

  completion_rate = calculate_completion_rate(providers)
  previous_completion_rate = calculate_completion_rate(
    providers.where('service_providers.created_at < ?', start_date)
  )
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


def calculate_performance_data(providers, start_date)
  result = providers.joins(:appointments)
    .where('appointments.created_at >= ?', start_date)
    .group("DATE_TRUNC('month', appointments.created_at)")
    .select(
      "DATE_TRUNC('month', appointments.created_at) as name",
      "COUNT(CASE WHEN appointments.status = 'completed' THEN 1 END) as completed",
      "COUNT(CASE WHEN appointments.status = 'cancelled' THEN 1 END) as cancelled"
    )
    .order('name')

  result.map do |data|
    {
      name: data.name.strftime('%b'),
      completed: data.completed.to_i,
      cancelled: data.cancelled.to_i
    }
  end
end



def calculate_service_distribution(providers, start_date)
  total = providers.count
  on_time = providers.joins(:appointments)
    .where('appointments.status = ? AND appointments.created_at >= ?', 'completed', start_date)
    .distinct
    .count

  [
    { name: 'On Time', value: on_time, color: '#22c55e' },
    { name: 'Late', value: (total * 0.1).round, color: '#eab308' },
    { name: 'Missed', value: (total * 0.05).round, color: '#ef4444' }
  ]
end


def calculate_completion_rate(providers)
  base_query = providers.joins(:appointments)
  total = base_query.count
  return 0 if total.zero?
  
  completed = base_query
    .where(appointments: { status: 'completed' })
    .count
  
  ((completed.to_f / total) * 100).round(1)
end


def format_change(value)
  return "+0" if value.zero?
  value.positive? ? "+#{value}" : value.to_s
end

end
