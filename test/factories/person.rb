FactoryGirl.define do
  factory :person do
    title {%w[M. Mme Mlle].sample}
    firstname { Faker::Name.first_name}
    lastname { Faker::Name.last_name}
    #email { "#{firstname.sub(/\s/,'_')}.#{lastname.sub(/\s/,'_')}@tryme.com".downcase }
    email {Faker::Internet.email}
    phone_number Faker::PhoneNumber.phone_number
    cell_phone_number Faker::PhoneNumber.cell_phone
    birthdate {(Date.today - (18..70).to_a.sample*365 + (1..364).to_a.sample).strftime("%F")}
    created_at {42.days.ago}
    user
  end
end
