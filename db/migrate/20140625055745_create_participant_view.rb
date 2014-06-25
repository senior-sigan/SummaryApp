class CreateParticipantView < ActiveRecord::Migration
  def up
    execute %{
      CREATE OR REPLACE VIEW participants as
        SELECT COUNT(*) as participations, records.email as email, MIN(records.name) as name, MIN(records.surname) as surname
        FROM records
        GROUP BY records.email;
    }
  end

  def down
    execute "DROP VIEW participants;"
  end
end
