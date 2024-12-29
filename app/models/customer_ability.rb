

class CustomerAbility
    include CanCan::Ability
    def initialize(customer)
        Rails.logger.info "initializing customer ability#{customer}"
        return unless  customer.present?
    # Rails.logger.info "initializing customer ability#{customer}"
    #                                 can  :verify_otp, Customer
    #                                 can :logout, Customer
    #                                 can :login, Customer
    #                                 can :confirm_request, Customer
    #                                 can :confirm_bag, Customer
                                    can :read, :get_chat_messages if customer
    can :manage, :create_chat_message if customer

    end


end