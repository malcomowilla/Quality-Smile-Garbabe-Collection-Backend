class SetTenant
  def initialize(app)
    @app = app
  end

  def call(env)
    request = ActionDispatch::Request.new(env)
    Rails.logger.info "Request object: #{request.inspect}"

    if host = request.headers['X-Original-Host']
      Rails.logger.info "Setting tenant for host: #{host}"
      begin
        account = Account.find_or_create_by(subdomain: host)
        ActsAsTenant.current_tenant = account
      rescue => e
        Rails.logger.error "Failed to set tenant for host #{host}: #{e.message}"
        # Continue with the request even if tenant setting fails
      end
    else
      Rails.logger.info "Request object: #{request.inspect}"

      Rails.logger.info "No X-Original-Host header found, skipping tenant setup"
    end

    @app.call(env)
  ensure
    # Clear the tenant after the request to prevent leaking between requests
    ActsAsTenant.current_tenant = nil
  end
end
