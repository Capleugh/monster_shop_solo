FactoryBot.define do
  factory :merchant do
    sequence(:name) { |n| "Merchant #{n}"}
    sequence(:address, 111) { |n| "#{n}" }
    city { "Denver" }
    state { "CO" }
    sequence(:zip, 111) { |n| "#{n}" }
  end
end
