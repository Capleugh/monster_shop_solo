FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "John #{n}" }
    sequence(:address) { |n| "#{n} Lane" }
    sequence(:city) { |n| "Den #{n}" }
    sequence(:state) { |n| "CO #{n}" }
    sequence(:zip) { |n| "8012#{n}" }
    sequence(:email) { |n| "johndoe#{n}@gmail.com" }
    password {"password"}
    password_confirmation {"password"}
    role {0}
  end
end
