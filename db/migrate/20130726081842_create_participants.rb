class CreateParticipants < ActiveRecord::Migration
  def change
    create_table :participants do |t|
      t.string :uuid, null: false
      t.string :name, null: false
      t.string :surname, null: false
      t.string :avatar
      t.string :meta

      t.timestamps
    end
    add_index :participants, :uuid, :unique => true
  end
end
