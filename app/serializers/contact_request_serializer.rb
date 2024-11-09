class ContactRequestSerializer < ActiveModel::Serializer
  attributes :id, :company_name, :business_type, :contact_person, :business_email, :phone_number, :expected_users
end
