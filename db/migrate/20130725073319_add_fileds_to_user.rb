class AddFiledsToUser < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :image, :string
    add_column :users, :gplus, :string
  end
end
