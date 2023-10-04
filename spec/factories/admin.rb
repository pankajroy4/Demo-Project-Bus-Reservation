FactoryBot.define do
  factory :admin , class: "User" do
    name { "Admin" }
    sequence :email do |n|
      "admin#{n}@gmail.com"
    end
    password { "111111" }
    user_type { "admin" }
  end
end
