class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name, null: false
      t.datetime :date, null: false
      t.string :social_url
      t.string :photo_url
      t.string :hash_tag
      t.integer :records_count, null: false, default: 0
      t.timestamps
    end
  end
end
