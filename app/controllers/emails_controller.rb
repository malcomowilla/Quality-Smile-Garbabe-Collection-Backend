class EmailsController < ApplicationController
  ActsAsTenant.with_tenant(ActsAsTenant.current_tenant) do
    before_action :set_email_settings




def set_email_settings
  @current_account = ActsAsTenant.current_tenant
  EmailSettingsConfigurator.configure(@current_account)
end



  def send_individual
    authorize! :manage, :send_individual
    
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
