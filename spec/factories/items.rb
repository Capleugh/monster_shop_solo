FactoryBot.define do
  factory :item do
    sequence(:name) { |n| "Toy #{n}"}
    description { "Great pull toy!" }
    sequence(:price, 5) { |n| "#{n}" }
    image {"http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg" }
    sequence(:inventory, 7 ) { |n| "#{n}" }
    merchant
  end
end
