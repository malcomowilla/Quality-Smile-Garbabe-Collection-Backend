class EmailsController < ApplicationController
  ActsAsTenant.with_tenant(ActsAsTenant.current_tenant) do

  def send_individual
    begin
      IndividualMailer.send_individual_email(
        to: params[:to],
        subject: params[:subject],
        message: params[:message]
      ).deliver_now
      
      render json: { message: 'Email sent successfully' }, status: :ok
    rescue => e
      Rails.logger.error "Error sending individual email: #{e.message}"
      render json: { error: 'Failed to send email' }, status: :unprocessable_entity
    end
  end
end
end
