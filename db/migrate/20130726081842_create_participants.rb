class CreateParticipants < ActiveRecord::Migration
  def change
    create_table :participants do |t|
      t.string :email, null: false
      t.string :first_name
      t.string :last_name
      t.string :stuff

      t.timestamps
    end
    add_index :participants, :email, :unique => true
  end
end
