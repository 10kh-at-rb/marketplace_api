class ProductsForUserSerializer < ActiveModel::Serializer
  attributes :id, :title, :price, :for_sale
end
