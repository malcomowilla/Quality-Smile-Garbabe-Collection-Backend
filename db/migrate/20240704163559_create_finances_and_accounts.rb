class CreateFinancesAndAccounts < ActiveRecord::Migration[7.1]
  def change
    create_table :finances_and_accounts do |t|
      t.string :category
      t.string :name
      t.string :description
      t.datetime :date
      t.string :reference

      t.timestamps
    end
  end
end
