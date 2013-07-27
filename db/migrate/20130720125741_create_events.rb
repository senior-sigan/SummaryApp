class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name, null: false
      t.datetime :date, null: false
      t.string :location  

      t.timestamps
    end
    add_index :events, :name, :unique => true
  end
end
