
class StoreManagerAbility
  include CanCan::Ability

  def initialize(store_manager)
    return unless store_manager.is_a?(StoreManager) && store_manager.present?

    can :verify_otp, StoreManager
    can :logout, StoreManager
    can :login, StoreManager
    can :confirm_delivered, StoreManager
    can :confirm_received, StoreManager
  end
end
