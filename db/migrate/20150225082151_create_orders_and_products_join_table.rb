class CreateOrdersAndProductsJoinTable < ActiveRecord::Migration
  def change
    create_join_table :orders, :products do |t|
      t.index :order_id
      t.index :product_id
    end
    add_foreign_key :orders_products, :orders, on_delete: :cascade
    add_foreign_key :orders_products, :products, on_delete: :cascade
  end
end
