FactoryBot.define do
  factory :bus_owner , class: "User" do
    name { "BusOwner" }
    sequence :email do |n|
      "busowner#{n}@gmail.com"
    end
    password { "111111" }
    sequence :registration_no do |n|
      "BUSOWNER#{n}12345"
    end
    user_type { "bus_owner" }
  end
end
