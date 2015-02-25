class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :created_at, :updated_at, :auth_token
  self.root = "data"
  has_many :products, embed: :ids, serializer: ProductsForUserSerializer
end
