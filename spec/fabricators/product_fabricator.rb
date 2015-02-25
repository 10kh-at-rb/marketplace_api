Fabricator(:product_without_user, from: Product) do
  title { Faker::Product.product_name }
  for_sale false
  price { rand(100) }
end

Fabricator(:product, from: :product_without_user) do
  user
end

Fabricator(:product_with_orders, from: :product) do
  orders(count: 3)
end
