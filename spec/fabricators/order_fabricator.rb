Fabricator(:order) do
  user
  products(count: 1)
end
