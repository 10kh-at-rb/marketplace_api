class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :user, index: true
      t.decimal :total, null: false

      t.timestamps null: false
    end
    add_foreign_key :orders, :users, on_delete: :cascade
  end
end
