class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.references :user, index: true
      t.string :title, null: false, default: ""
      t.boolean :for_sale, default: false
      t.decimal :price, precision: 8, scale: 2, default: 0.00, null: false

      t.timestamps null: false
    end
    add_foreign_key :products, :users
  end
end
