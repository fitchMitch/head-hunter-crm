FactoryBot.define do
  factory :job do
    job_title             {Faker::Company.profession }
    salary                (17..45).to_a.sample* 1000-17
    start_date            { Date.today - (0..20).to_a.sample* 365 + (1..364).to_a.sample }
    end_date              {start_date + (100 *(1..15).to_a.sample)}
    created_at            {Date.today }
    updated_at            {Date.today }
    no_end                false
    company
    person
  end
end
