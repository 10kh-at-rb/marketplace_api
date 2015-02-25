Fabricator(:user) do
  name { Faker::Lorem.characters(4) }
  email { Faker::Internet.email }
  password 'foobarfoo'
  password_confirmation 'foobarfoo'
end

Fabricator(:user_with_products, from: :user) do
  products(count: 3)
end

Fabricator(:user_with_orders, from: :user) do
  orders(count: 3)
end
