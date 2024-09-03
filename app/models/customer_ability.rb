

class CustomerAbility
    include CanCan::Ability
    def initialize(customer)
        Rails.logger.info "initializing customer ability#{customer}"
        return unless customer.is_a?(Customer) && customer.present?
    Rails.logger.info "initializing customer ability#{customer}"
                                    can  :verify_otp, Customer
                                    can :logout, Customer
                                    can :login, Customer
                                    can :confirm_request, Customer
                                    can :confirm_bag, Customer
    end
end