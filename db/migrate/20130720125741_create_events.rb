class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name, null: false
      t.datetime :evdate, null: false  

      t.timestamps
    end
    add_index :events, :name, :unique => true
  end
end
