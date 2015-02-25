class ChangeOrderTotalDefault < ActiveRecord::Migration
  def change
    change_column :orders, :total, :decimal, default: 0.0
  end
end
