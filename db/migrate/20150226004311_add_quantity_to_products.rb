class AddQuantityToProducts < ActiveRecord::Migration
  def change
    add_column :products, :quantity, :integer, null: false, default: 0
  end
end
