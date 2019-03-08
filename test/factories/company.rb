FactoryBot.define do
  factory :company do
    company_name { Faker::Company.unique.name }
    association :company_representative, factory: :person
  end
end
