FactoryBot.define do
  factory :bus do
    name { "Volvo Bus" }
    route { "Patna - Delhi" }
    total_seat { 50 }
    registration_no { "AB12345" }
    approved { false }
    association :bus_owner
  end
end