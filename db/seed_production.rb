# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'as-duration'
#-----------------
# Common
#-----------------
created_at=           Time.zone.now
updated_at=           Time.zone.now
#-----------------
# Users
#-----------------
User.create!(name:                   'Etienne WEIL',
    email:                 "weil.etienne@hotmail.fr",
    password:              "123456",
    password_confirmation: "123456",
    admin:                  true,
    activated: true,
    activated_at: Time.zone.now)
User.create!(name:                   'Flora CLERC',
    email:                 "flora.clerc@juinjuillet.fr",
    password:              "123456",
    password_confirmation: "123456",
    admin:                  true,
    activated: true,
    activated_at: Time.zone.now)
