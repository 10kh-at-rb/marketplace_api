Fabricator(:product) do
  user
  title { Faker::Product.product_name }
  for_sale false
  price { rand(100) }
end
