class DropOldSequenceNumberSequence < ActiveRecord::Migration[7.1]
  def change
    # Drop the sequence if it exists
    execute <<-SQL
      DO $$
      BEGIN
        IF EXISTS (SELECT 1 FROM pg_class WHERE relkind = 'S' AND relname = 'service_providers_sequence_number_seq') THEN
          DROP SEQUENCE service_providers_sequence_number_seq;
        END IF;
      END
      $$;
    SQL
  end
end
