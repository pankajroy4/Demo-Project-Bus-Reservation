FactoryBot.define do
  factory :user do
    name { "User" }
    sequence :email do |n|
      "user#{n}@gmail.com"
    end
    password { "111111" }
    user_type { "user" }
  end
end