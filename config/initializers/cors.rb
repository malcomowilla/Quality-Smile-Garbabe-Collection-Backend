Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins 'http://localhost:5173', 
      'https://aitechs-sas-garbage-solution.onrender.com', 
      
      'http://localhost:3000', 'https://aitechs-saas.onrender.com'


      # origins ['http://localhost:5173', 'https://74jp5ccr-5173.uks1.devtunnels.ms', 'https://another-origin.com']
      resource '*', headers: :any, methods: [:get, :post, :put, :patch, :delete, :options, :head], credentials: true, expose: ['access-token', 'expiry', 'token-type', 'uid', 'client']
    end
  end