
  def change
    # Adding the column without the auto-increment setup
 add_column :customers, :sequence_number, :integer

 # Create a sequence
 execute <<-SQL
   CREATE SEQUENCE customers_sequence_number_seq START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
 SQL

 # Set the sequence as the default value for the column
 execute <<-SQL
   ALTER TABLE customers ALTER COLUMN sequence_number SET DEFAULT nextval('customers_sequence_number_seq');
 SQL
end


add_column :customers, :bag_confirmed, :boolean, default: false
