

class ServiceProviderAbility
    include CanCan::Ability
    def initialize(service_provider)
        return unless service_provider.is_a?(ServiceProvider) && service_provider.present?
        can :verify_otp, ServiceProvider
        can :logout, ServiceProvider
        can :login, ServiceProvider
        can :confirm_delivered, ServiceProvider
        can :confirm_collected, ServiceProvider
    end
end








