class CreateAdmins < ActiveRecord::Migration
  def change
    create_table :admins do |t|
      t.string :email, null: false
      t.string :authentication_token
      t.boolean :approved, null: false, default: false

      t.timestamps
    end

    add_index :admins, :email, unique: true
    add_index :admins, :authentication_token, unique: true
  end
end
