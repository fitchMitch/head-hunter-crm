FactoryBot.define do
  factory :person do
    firstname { Faker::Name.first_name }
    lastname { Faker::Name.last_name }
    #email { "#{firstname.sub(/\s/, '_')}.#{lastname.sub(/\s/, '_')}@tryme.com".downcase }
    email {Faker::Internet.email }
    phone_number Faker::PhoneNumber.phone_number
    approx_age { (20..64).to_a.sample}
    created_at {42.days.ago }
    note { Faker::Lorem.sentence(4)}
    is_jj_hired {false}
    is_client {false}
    user
  end
  factory :person_with_cv, class: Person do
    firstname { Faker::Name.first_name }
    lastname { Faker::Name.last_name }
    #email { "#{firstname.sub(/\s/, '_')}.#{lastname.sub(/\s/, '_')}@tryme.com".downcase }
    email {Faker::Internet.email }
    phone_number Faker::PhoneNumber.phone_number
    approx_age { (20..64).to_a.sample}
    created_at {42.days.ago }
    note { Faker::Lorem.sentence(4)}
    is_jj_hired {false}
    is_client {false}
    cv_docx { File.new("#{Rails.root}/test/factories/test.docx")}
    user
  end
end
