class ServiceProviderStatsController < ApplicationController
  
  def service_provider_stats
    authorize! :read, :service_provider_stats
    total_stats = {
      total_delivered_confirmation: ServiceProvider.sum(:total_delivered_confirmation),
      total_collection_confirmation: ServiceProvider.sum(:total_collection_confirmation)
    }

    service_provider_stats = ServiceProvider.select(:id, :name, :email,
     :total_delivered_confirmation,
     :total_collection_confirmation, :provider_code, :date_collected, 
     :date_delivered,)
                           .where.not(total_delivered_confirmation: nil)
                           .or(ServiceProvider.where.not(
                            total_collection_confirmation: nil))
                           .order(total_delivered_confirmation: :desc)
                           .map do |service_provider|
      service_provider.as_json.merge(
        date_delivered: service_provider.formatted_delivered_date,
        date_collected: service_provider.formatted_collected_date,
        last_delivered_date: service_provider.formatted_delivered_date,
        last_collected_date: service_provider.formatted_collected_date
      )
    end

    render json: {
      total_stats: total_stats,
      service_provider_stats: service_provider_stats
    }
  end


end