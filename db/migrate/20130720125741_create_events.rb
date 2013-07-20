class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.integer :group_id

      t.timestamps
    end
    add_index :events, :name, :unique => true
  end
end
