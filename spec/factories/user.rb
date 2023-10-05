FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { "111111" }
    user_type { "user" }
    confirmed_at { Time.now }
  end
end
