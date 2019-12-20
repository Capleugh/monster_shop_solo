FactoryBot.define do
  factory :order do
    sequence(:name) { |n| "Name#{n}"}
    sequence(:address, 100) { |n| "#{n}"}
    city { "Den" }
    state { "CO" }
    sequence(:zip, 11111) { |n| "#{n}"}
    user
  end
end
