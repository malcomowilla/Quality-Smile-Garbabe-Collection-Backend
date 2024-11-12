class Admin < ApplicationRecord
    attr_accessor :skip_password_validation
    has_secure_password(validations: false)
    has_secure_token :reset_password_token
    has_one_attached :profile_image
    has_many :conversations, counter_cache: true
acts_as_tenant(:account)
   

    # has_many :prefix_and_digits_for_ticket_numbers, dependent: :destroy
has_many :credentials


# has_many :messages
# has_many :chat_rooms, through: :messages

# has_many :messages_sent, class_name: 'Message', foreign_key: 'sender_id', dependent: :destroy
# has_many :messages_received, class_name: 'Message', foreign_key: 'receiver_id', dependent: :destroy



# encrypts :email, :password,   :fcm_token,  deterministic: true
enum :role,  [:super_administrator, :store_manager, :customer, :service_provider,
 :customer_support,  :administrator, :agent]
 has_many :conversations, dependent: :destroy


# def skip_password_validation
#     skip_password_validation == '1' || skip_password_validation == true
#   end


def as_json(options = {})
super(options).merge(
  online: online,
  last_seen: last_seen
)
end


  def skip_password_validation=(value)
    @skip_password_validation = value
  end

# def super_administrator_role?
#     role == 'super_administrator'
# end



# self.where(connection_count: nil).update_all(connection_count: 0)
# scope :online, -> { where('connection_count > 0') }
# scope :offline, -> { where(connection_count: 0) }

# def came_online
#   with_lock do
#    old_count = reload.connection_count
#    update!(connection_count: old_count + 1)
#   end
#   online_status_changes.create!(status: :online) if old_count.zero?

# end

# def went_offline
#   with_lock do
#    old_count = reload.connection_count
#    update!(connection_count: old_count - 1)
#   end
#   online_status_changes.create!(status: :offline) if connection_count.zero?

# end



def generate_password_reset_token(admin)
    # SecureRandom.urlsafe_base64
    # self.reset_password_token = generate_token

    # self.reset_password_sent_at = Time.now.utc
    admin.update_column(:reset_password_token, generate_token)
    admin.update_column(:reset_password_sent_at, Time.now)

end
def reset_password(password, admin)
    admin.update(password: password)
    admin.update(reset_password_token: nil)
end

def password_token_valid?
    (reset_password_sent_at + 4.hours) > Time.now.utc
end



def generate_otp(admin)
    otp = self.otp = rand(100000..999999).to_s
    # self.password = SecureRandom.base64(8)
    admin.update_column(:otp, otp)
    # self.password = nil
    
end


def generate_login_password
    self.password = SecureRandom.base64(8)
    
    save
end

def skip_password_validation=(value)
    @skip_password_validation = value
  end




def verify_otp(submitted_otp)
    self.otp == submitted_otp
    
  end


  
#   validates :password, presence: true,unless: :skip_password_validation?

    # validates :password_confirmation, confirmation: { presence: true},unless: :skip_password_validation?

    # validate :validate_complex_password, unless: :skip_password_validation
    
    # validates :email,  format: { with: URI::MailTo::EMAIL_REGEXP }, presence: true
    # validate :validate_email_format
    validates :user_name, uniqueness: true

    private
    def validate_email_format
        unless email.end_with?('@gmail.com') || email.end_with?('co.ke')
            errors.add(:email, 'must be a valid email adress ending with gmail.com')
        end
    end
    
    def skip_password_validation?
        skip_password_validation
      end

    # validates :password, presence: true, uniqueness: true
    # validates :password, uniqueness: true, presence: true
    # validate :validate_complex_password
    
       
    
    
    
    def validate_complex_password
        if password.present? and !password.match(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{12,}$/) 
            errors.add :password, "must include at least one lowercase letter, one uppercase letter, one digit,
             and needs to be minimum 12 characters."
    
    
          end
    end
end







def generate_token
    # SecureRandom.hex(10)
    SecureRandom.base64(16)
end
