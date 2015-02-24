class ProductSerializer < ActiveModel::Serializer
  has_one :user
  attributes :id, :title, :price, :for_sale
  self.root = "data"
end
