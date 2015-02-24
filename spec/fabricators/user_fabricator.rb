Fabricator(:user) do
  name { Faker::Lorem.characters(4) }
  email { Faker::Internet.email }
  password 'foobarfoo'
  password_confirmation 'foobarfoo'
end
