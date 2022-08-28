FactoryBot.define do
  factory :item do
    name { Faker::Food.dish }
    description { Faker::Food.description }
    unit_price { Faker::Number.decimal(r_digits: 2) }
    merchant_id { Faker::Number.between(from: 1, to: 3)}
  end
end
