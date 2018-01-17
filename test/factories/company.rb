FactoryBot.define do
  factory :company do
    company_name { Faker::Company.unique.name }
  end
end
