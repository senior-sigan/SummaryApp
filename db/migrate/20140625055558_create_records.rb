class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.string :email, null: false
      t.string :name, null: false
      t.string :surname, null: false
      t.boolean :presence, null: false, default: true
      t.json :meta
      t.references :event
      t.timestamps
    end

    add_index :records, :email
    add_index :records, [:email, :event_id], unique: true
  end
end
