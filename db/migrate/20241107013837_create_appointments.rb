class CreateAppointments < ActiveRecord::Migration[7.1]
  def change
    create_table :appointments do |t|
      t.references :service_provider, null: false, foreign_key: true
      t.references :account, null: false, foreign_key: true
      t.string :status, default: 'pending'
      t.datetime :appointment_date
      t.text :notes

      t.timestamps

    end
    add_index :appointments, [:account_id, :service_provider_id]

  end
end
