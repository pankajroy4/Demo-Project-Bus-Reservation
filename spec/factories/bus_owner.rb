FactoryBot.define do
  factory :bus_owner , class: User do
    name { "Angad" }
    email { "angad@gmail.com" }
    password { "111111" }
    registration_no {"ANGAD96PR34"}
    user_type { "bus_owner" }
  end
end