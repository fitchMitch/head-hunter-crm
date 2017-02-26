# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'as-duration'

User.create!(name:                  "Etienne WEIL",
             email:                 "weil.etienne@hotmail.fr",
             password:              "123456",
             password_confirmation: "123456",
             admin:                  true,
             activated: true,
             activated_at: Time.zone.now)

55.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:                  name,
               email:                 email,
               password:              password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end
10.times do |n|
  company_name = Faker::Company.name
  Company.create!( company_name:      company_name )
end

companies=Company.all
company=companies.first
user = User.all.first

Person.create!( title:              "Mme",
                firstname:          "Yolande",
                lastname:           "Moreau",
                email:              "yolande.moreau@gmail.com",
                phone_number:       "9876543210",
                cell_phone_number:  "+33 12345679",
                birthdate:          "04/07/1980",
                is_jj_hired:        true,
                is_client:          false,
                note:               Faker::Lorem.sentence(1),
                user_id:            user.id
                )
10.times do |n|
  title=              Faker::Name.title
  firstname=          Faker::Name.first_name
  lastname=           Faker::Name.last_name
  email=              Faker::Internet.email
  phone_number=       Faker::PhoneNumber.phone_number
  cell_phone_number=  Faker::PhoneNumber.cell_phone

  birthdate=          (Date.today - (18..70).to_a.sample*365 + (1..364).to_a.sample).strftime("%F")
  #Time.zone.now.parse(Faker::Time:between(70.years.ago, 18.years.ago)).strftime("%F")
  note=               Faker::Lorem.sentence(3)
  is_client =         Faker::Boolean.boolean(0.1)
  user_id=            user.id
  Person.create!( title:              title,
                  firstname:          firstname,
                  lastname:           lastname,
                  email:              email,
                  phone_number:       phone_number,
                  cell_phone_number:  cell_phone_number,
                  birthdate:          birthdate,
                  is_jj_hired:        is_client,
                  is_client:          is_client,
                  note:               note,
                  user_id:            user_id
                  )
end
people = Person.all

45.times do |n|
  person = people.sample

  job_title=             Faker::Company.profession
  salary=                n*100-n*2

  start_date=            Date.today
  start_date -=          (18..70).to_a.sample*365
  start_date +=          (1..364).to_a.sample
  end_date=              start_date + (100*n)

  end_date=              end_date.strftime("%F")
  start_date=            start_date.strftime("%F")
  created_at=            Time.zone.now
  updated_at=            Time.zone.now
  company_id=            company.id
  person_id=             person.id
  Job.create!( job_title:             job_title,
               salary:                salary,
               start_date:            start_date,
               end_date:              end_date,
               jj_job:                false,
               created_at:            created_at,
               updated_at:            updated_at,
               company_id:            company_id,
               person_id:             person_id,
               no_end:                false
               )
end
