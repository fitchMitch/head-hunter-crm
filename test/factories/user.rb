FactoryBot.define do
  factory :user do
    name                    "Gargamel"
    email                   {Faker::Internet.email }
    password_digest         {User.digest('password')}
    admin                   false
    activated               true
    activated_at            {Date.today }
  end
  factory :user2, class: User do
    name                    "Azrael"
    email                   {Faker::Internet.email }
    password_digest         {User.digest('password')}
    admin                   false
    activated               true
    activated_at            {Date.today }
  end
  factory :admin, class: User do
    name                    "Admin"
    email                   {Faker::Internet.email }
    password_digest         {User.digest('password')}
    admin                   true
    activated               true
    activated_at            {Date.today }
  end
end
