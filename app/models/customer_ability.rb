

class CustomerAbility
    include CanCan::Ability
    def initialize(customer)
        return unless customer.is_a?(Customer) && customer.present?
    
                                    can :verify_otp, Customer
                                    can :logout, Customer
                                    can :login, Customer
                                    can :confirm_request, Customer
                                    can :confirm_bag, Customer
    end
end