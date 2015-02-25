class OrderSerializer < ActiveModel::Serializer
  has_many :products, serializer: ProductOrderSerializer
  attributes :id, :total
  self.root = "data"
end
