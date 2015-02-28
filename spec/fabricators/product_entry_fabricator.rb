Fabricator(:product_entry) do
  order
  product { Fabricate(:product, quantity: 10) }
end
