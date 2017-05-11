FactoryGirl.define do
  factory :company do
    company_name {Faker::Company.name }
    created_at {(18..70).to_a.sample.days.ago }
  end
end
