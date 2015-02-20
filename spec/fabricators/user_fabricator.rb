Fabricator(:user) do
  email { Faker::Internet.email }
  password 'foobarfoo'
  password_confirmation 'foobarfoo'
end
