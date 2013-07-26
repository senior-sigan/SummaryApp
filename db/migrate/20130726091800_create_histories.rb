class CreateHistories < ActiveRecord::Migration
  def change
    create_table :histories do |t|
      t.integer :commit_id, null: false
      t.integer :participant_id, null: false
      t.integer :category_id, null: false
      t.integer :event_id, null: false
      t.integer :score, null: false

      #t.timestamps
    end
  end
end
