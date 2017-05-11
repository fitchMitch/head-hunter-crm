# Table name: comactions
#
#  id         :integer          not null, primary key
#  name       :string
#  status     :string
#  type       :string
#  start_time   :datetime
#  end_time   :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#  mission_id :integer
#  person_id  :integer
FactoryGirl.define do
  factory :comaction do
    # job_title             {Faker::Company.profession}
    # salary                (17..45).to_a.sample*1000-17
    # start_date            { Date.today - (0..20).to_a.sample*365 + (1..364).to_a.sample}
    # end_date              {start_date + (100*(1..15).to_a.sample)}
    # created_at            {Date.today}
    # updated_at            {Date.today}
    # no_end                false
    # company
    # person
    name                    { 'action commerciale' + (17..4500).to_a.sample.to_s}
    status                  {Comaction::comstatus.sample}
    action_type             {Comaction::action_types.sample}
    start_time              { Date.today +(1..40).to_a.sample}
    end_time                { start_time + (1..4).to_a.sample/24}
    user
    misssion
    person
  end
end
