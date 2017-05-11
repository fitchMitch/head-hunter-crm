FactoryGirl.define do
  factory :mission do

    name               "Mission" + (1..4500).to_a.sample.to_s
    reward             (17..45).to_a.sample* 1000
    paid_amount        {reward / 3 }
    min_salary         (200..400).to_a.sample* 100
    max_salary         {min_salary.to_i + (1..10).to_a.sample.to_i* 1000 }
    criteria           {Faker::Lorem.paragraph(3, true, 4)}
    min_age            (18..60).to_a.sample
    max_age            {min_age + (10..20).to_a.sample }
    signed             false
    is_done            false
    whished_start_date { Date.today + (0..200).to_a.sample }
    person
    company
  end
end
