Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)

FactoryBot.define do
  factory :merchant do
    sequence(:name) { |n| "Merchant #{n}"}
    sequence(:address, 111) { |n| "#{n}" }
    city { "Denver" }
    state { "CO" }
    sequence(:zip, 111) { |n| "#{n}" }
  end
end
