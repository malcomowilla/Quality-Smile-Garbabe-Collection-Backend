class ContactRequest < ApplicationRecord
  validates :company_name, presence: true
  validates :business_type, presence: true
  validates :contact_person, presence: true
  validates :business_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone_number, presence: true
  validates :expected_users, presence: true
end
