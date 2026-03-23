FactoryBot.define do
  factory :quote do
    customer      { Faker::Company.name }
    supplier      { Faker::Company.name }
    quote         { rand(0.05..0.15).round(4) }
    tax_included  { [true, false].sample }
  end
end