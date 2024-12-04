class Credential < ApplicationRecord
  # belongs_to :admin
  # belongs_to :system_admin

  # belongs_to :system_admin, optional: true # Reference to SystemAdmin
  belongs_to :admin, optional: true # Reference to Admin

end
