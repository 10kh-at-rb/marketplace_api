class AddNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string, null: false
    add_index :users, :name, unique: true
  end
end
