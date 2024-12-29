class RemoveStatusFromServiceProvider < ActiveRecord::Migration[7.1]
  def change
    remove_column :service_providers, :status, :string
  end
end
