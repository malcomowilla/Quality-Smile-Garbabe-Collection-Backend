
class CustomerStatsController < ApplicationController

  def customer_stats
    authorize! :read, :customer_stats
    total_stats = {
      total_requests: Customer.sum(:total_requests),
      total_confirmations: Customer.sum(:total_confirmations)
    }

    customer_stats = Customer.select(:id, :name, :email, :total_requests,
     :total_confirmations, :customer_code, :request_date, :confirmation_date)
                           .where.not(total_requests: nil)
                           .or(Customer.where.not(total_confirmations: nil))
                           .order(total_requests: :desc)
                           .map do |customer|
      customer.as_json.merge(
        request_date: customer.formatted_request_date,
        confirmation_date: customer.formatted_confirmation_date,
        last_request: customer.formatted_request_date,
        last_confirmation: customer.formatted_confirmation_date
      )
    end

    render json: {
      total_stats: total_stats,
      customer_stats: customer_stats
    }
  end


end