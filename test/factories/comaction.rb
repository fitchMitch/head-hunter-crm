# Table name: comactions
#
#  id          :integer          not null, primary key
#  name        :string
#  status      :string
#  action_type :string
#  start_time  :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer
#  mission_id  :integer
#  person_id   :integer
#  end_time    :datetime

FactoryBot.define do
  factory :comaction do
    name                    { 'action commerciale' + (17..4500).to_a.sample.to_s }
    status                  {Comaction::STATUSES.sample }
    action_type             {Comaction::ACTION_TYPES.sample }
    start_time              { Time.now.beginning_of_day + ((1..40).to_a.sample * 24 + (7..20).to_a.sample ) * 60 * 60 }
    end_time                { start_time + ((2..4).to_a.sample/2 ) * 60 * 60 }
    user
    mission
    person
  end

  factory :former_comaction, class: Comaction do
    name                    { 'former action commerciale' + (17..4500).to_a.sample.to_s }
    status                  {Comaction::STATUSES.sample }
    action_type             {Comaction::ACTION_TYPES.sample }
    start_time              { Time.now.beginning_of_day + ((-46..-4).to_a.sample  * 24 + (7..20).to_a.sample )* 60 * 60 }
    end_time                { start_time + ((2..4).to_a.sample/2) * 60 * 60 }
    user
    mission
    person
  end
end
