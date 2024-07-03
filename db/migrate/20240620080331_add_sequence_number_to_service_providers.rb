class AddSequenceNumberToServiceProviders < ActiveRecord::Migration[7.1]

  def change
    # Adding the column without the auto-increment setup
 add_column :service_providers, :sequence_number, :integer

 # Create a sequence
 execute <<-SQL
   CREATE SEQUENCE service_providers_sequence_number_seq START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
 SQL

 # Set the sequence as the default value for the column
 execute <<-SQL
   ALTER TABLE service_providers ALTER COLUMN sequence_number SET DEFAULT nextval('service_providers_sequence_number_seq');
 SQL
end


end
