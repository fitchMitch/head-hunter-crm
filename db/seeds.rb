# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# User.create!(name:                  "Etienne WEIL",
#              email:                 "weil.etienne@hotmail.fr",
#              password:              "123456",
#              password_confirmation: "123456",
#              admin:                  true,
#              activated: true,
#              activated_at: Time.zone.now)

# 99.times do |n|
#   name  = Faker::Name.name
#   email = "example-#{n+1}@railstutorial.org"
#   password = "password"
#   User.create!(name:                  name,
#                email:                 email,
#                password:              password,
#                password_confirmation: password,
#                activated: true,
#                activated_at: Time.zone.now)
# end

Person.create!( title: "Mme",
                firstname:          "Yolande",
                lastname:           "Moreau",
                email:              "yolande.moreau@gmail.com",
                phone_number:       "9876543210",
                cell_phone_number:  "+33 12345679",
                birthdate:          "04/07/1980",
                is_jj_hired:        true,
                is_client:          false,
                note:               "Exemple de note a priori bien courte")
