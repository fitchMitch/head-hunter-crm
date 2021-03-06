# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'as-duration'
# -----------------
# Common
# -----------------
created_at =          Time.zone.now
updated_at =          Time.zone.now
# -----------------
# Users
# -----------------
User.create!(
    name:                   'Etienne WEIL',
    email:                 'weil.etienne@hotmail.fr',
    password:              '123456',
    password_confirmation: '123456',
    admin:                  true,
    activated: true,
    activated_at: Time.zone.now
  )

3.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = 'password'
  User.create!(name:                  name,
    email:                 email,
    password:              password,
    password_confirmation: password,
    activated: true,
    activated_at: Time.zone.now)
end
users = User.all
# -----------------
# Companies
# -----------------
9.times do |n|
  company_name = Faker::Company.name
  Company.create!(company_name:      company_name )
end
companies=Company.all
# -----------------
# People
# -----------------
user = users.sample

Person.create!(
    firstname:          'Yolande',
    lastname:           'Moreau',
    email:              'yolande.moreau@gmail.com',
    phone_number:       '9876543210',
    approx_age:         65,
    is_hh_hired:        true,
    is_client:          false,
    note:               Faker::Lorem.sentence(1),
    user_id:            user.id
    )
18.times do |n|
  company=companies.sample
  user = users.sample
  firstname=         Faker::Name.first_name
  lastname=          Faker::Name.last_name
  email=             Faker::Internet.email
  phone_number=      Faker::PhoneNumber.phone_number

  approx_age=         (18..70).to_a.sample
  # Time.zone.now.parse(Faker::Time:between(70.years.ago, 18.years.ago)).strftime("%F")
  note=              Faker::Lorem.sentence(3)
  is_client =        Faker::Boolean.boolean(0.1)
  user_id=           user.id
  Person.create!(
    firstname:          firstname,
    lastname:           lastname,
    email:              email,
    phone_number:       phone_number,
    approx_age:         approx_age,
    cv_docx:            nil,
    is_hh_hired:        is_client,
    is_client:          is_client,
    note:               note,
    user_id:            user_id
    )
end
people = Person.all

# -----------------
# Jobs
# -----------------
75.times do |n|
  person = people.sample
  company=companies.sample

  job_title=            Faker::Company.profession
  salary=               n* 100-n* 2

  start_date=           Date.today
  start_date -=         (1..40).to_a.sample* 365
  start_date +=         (1..364).to_a.sample
  end_date=             start_date + (100 *(n+1 ))

  end_date=             end_date.strftime("%F")
  start_date=           start_date.strftime("%F")
  # puts start_date
  # puts end_date
  # puts '---------------------'

  company_id=           company.id
  person_id=            person.id
  Job.create!(job_title:             job_title,
    salary:                salary,
    start_date:            start_date,
    end_date:              end_date,
    hh_job:                false,
    created_at:            created_at,
    updated_at:            updated_at,
    company_id:            company_id,
    person_id:             person_id,
    no_end:                false
    )
end
jobs= Job.all
# -----------------
# Missions
# -----------------
# statuses = ['Opportunité', 'Contrat envoyé', 'Contrat signé', 'Mission facturée', 'Mission payée']
35.times do |n|
  person = people.sample
  company = companies.sample
  user = users.sample

  name   =           'Mission' + (1..4500).to_a.sample.to_s
  reward =           (17..45).to_a.sample* 1000
  min_salary =       (200..400).to_a.sample* 100
  max_salary  =      min_salary +(1..10).to_a.sample* 1000
  criteria  =        Faker::Lorem.paragraph(3, true, 4)
  whished_start_date = Date.today + (0..200).to_a.sample
  company_id =       company.id
  person_id  =       person.id
  user_id  =         user.id
  status  =          Mission.statuses.keys.sample.to_sym
  is_done   =        [:mission_billed, :mission_payed].include?(status)
  signed    =        [:contract_signed, :mission_billed, :mission_payed].include?(status)
  paid_amount =      signed ? reward / 3 : 0
  signed_at =        signed ? Date.today - (0..100).to_a.sample : nil
  Mission.create!(
    name:               name,
    reward:             reward,
    paid_amount:        paid_amount,
    min_salary:         min_salary,
    max_salary:         max_salary,
    criteria:           criteria,
    signed:             signed,
    is_done:            is_done,
    whished_start_date: whished_start_date,
    created_at:         created_at,
    updated_at:         updated_at,
    company_id:         company_id,
    person_id:          person_id,
    user_id:            user_id,
    status:             status,
    signed_at:          signed_at
    )
end
missions = Mission.all
# -----------------
# Comactions
# -----------------
250.times do |n|

  name   =           'Rendez-vous ' + n.to_s
  status =           Comaction.statuses.keys.sample
  action_type   =    Comaction.action_types.keys.sample
  person =           people.sample
  user   =           users.sample
  mission=           missions.sample
  created_at =       Date.today - (200..480).to_a.sample
  updated_at =       created_at +  (1..150).to_a.sample
  start_time   =     (0..100).to_a.sample >15 ? Time.now.beginning_of_day + ((-20..25).to_a.sample * 24 + (7..19).to_a.sample) * 60 * 60  : nil
  end_time    =      start_time.nil?  ? nil : start_time + (1..3).to_a.sample * 60 * 60

  Comaction.create(
    name:               name,
    status:             status,
    action_type:        action_type,
    start_time:         start_time,
    end_time:           end_time,
    created_at:         created_at,
    updated_at:         updated_at,
    mission_id:         mission.id,
    person_id:          person.id,
    user_id:            user.id
    )
end
comactions = Comaction.all
