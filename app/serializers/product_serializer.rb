class ProductSerializer < ActiveModel::Serializer
  attributes :id, :title, :price, :for_sale
  self.root = "data"
end
