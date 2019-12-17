FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "John #{n}" }
    sequence(:address) { |n| "#{n} Lane" }
    sequence(:city) { |n| "Den #{n}" }
    sequence(:state) { |n| "CO #{n}" }
    sequence(:zip) { |n| "8012#{n}" }
    sequence(:email) { |n| "johndoe1@gmail.com" }
    sequence(:password) { |n| "password#{n}" }
    sequence(:password_confirmation) { |n| "password#{n}" }
  end
end
