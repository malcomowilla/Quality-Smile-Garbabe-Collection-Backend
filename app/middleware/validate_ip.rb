class ValidateIp
  def initialize(app)
    @app = app
  end

  def call(env)
    # Extract forwarded IP from header (if any)
    forwarded_for = env['HTTP_X_FORWARDED_FOR']
    client_ip = forwarded_for ? forwarded_for.split(',').first.strip : env['REMOTE_ADDR']

    # Your custom logic for validating IP
    if !valid_ip?(client_ip)
      return [403, {'Content-Type' => 'text/plain'}, ['Forbidden']]
    end

    @app.call(env)
  end

  private

  def valid_ip?(ip)
    # Add your validation logic here
    # Example: Allow IPs only from trusted range
    trusted_ips = ['192.168.0.0/16', '10.0.0.0/8']
    trusted_ips.any? { |range| IPAddr.new(range).include?(ip) }
  end
end
