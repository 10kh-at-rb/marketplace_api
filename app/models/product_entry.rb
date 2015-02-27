class ProductEntry < ActiveRecord::Base
  belongs_to :order, inverse_of: :product_entries
  belongs_to :product, inverse_of: :product_entries
end
