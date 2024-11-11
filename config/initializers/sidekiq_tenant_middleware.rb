
class SidekiqTenantMiddleware
  def call(worker, job, queue)
    # Get domain and subdomain from job arguments
    domain = job['domain']
    subdomain = job['subdomain']

    if domain && subdomain
      account = Account.find_or_create_by(domain: domain, subdomain: subdomain)
      ActsAsTenant.with_tenant(account) do
        yield
      end
    else
      yield
    end
  end
end



