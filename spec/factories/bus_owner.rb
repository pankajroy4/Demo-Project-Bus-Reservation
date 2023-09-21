FactoryBot.define do
  factory :bus_owner do
    name { "Angad" }
    email { "angad@gmail.com" }
    password { "111111" }
    user_type { "bus_owner" }
  end
end