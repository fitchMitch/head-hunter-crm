# require 'as-duration'
#-----------------
# Common
#-----------------
created_at=           Time.zone.now
updated_at=           Time.zone.now
#-----------------
# Users
#-----------------
User.create!(
  name:                  'Etienne WEIL',
  email:                 'weil.etienne@hotmail.fr',
  password:              '123456',
  password_confirmation: '123456',
  admin:                  true,
  activated:              true,
  activated_at:           Time.zone.now
)
