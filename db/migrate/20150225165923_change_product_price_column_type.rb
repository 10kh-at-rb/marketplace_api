class ChangeProductPriceColumnType < ActiveRecord::Migration
  def change
    change_column :products, :price, :decimal, default: 0.0
  end
end
