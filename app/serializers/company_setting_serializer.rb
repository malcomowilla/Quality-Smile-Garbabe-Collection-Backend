class CompanySettingSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::AssetUrlHelper
  attributes :id, :company_name, :contact_info, :email_info


  # def logo_url
  #   if object.logo.attached?
  #     # Return a relative path
  #     Rails.application.routes.url_helpers.rails_blob_path(object.logo, only_path: true)
  #   else
  #     nil
  #   end
  # end
end
