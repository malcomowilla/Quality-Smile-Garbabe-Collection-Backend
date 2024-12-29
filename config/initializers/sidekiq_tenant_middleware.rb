class SidekiqTenantMiddleware
  def call(worker, job, queue)
    ActsAsTenant.with_tenant(ActsAsTenant.current_tenant) do
      yield
    end
  end
end
