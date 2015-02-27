class RenameOrdersProductsToProductEntries < ActiveRecord::Migration
  def change
    rename_table :orders_products, :product_entries
    add_column :product_entries, :quantity, :integer, null: false, default: 0
  end
end
