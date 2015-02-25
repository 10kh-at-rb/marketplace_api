class OrderSerializer < ActiveModel::Serializer
  attributes :id
  self.root = "data"
end
