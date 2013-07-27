class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records, id: false do |t|
      t.integer :participant_id, null: false
      t.integer :category_id, null: false
      t.integer :event_id, null: false
      t.integer :score, null: false
    end
    add_index :records, [
      :participant_id,
      :category_id,
      :event_id], unique: true
  end
end
