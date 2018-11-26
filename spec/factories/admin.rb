FactoryBot.define do
  factory :admin do
    email                 { Faker::Internet.email }
    name                  { Faker::Name.name }
    password              { Faker::Internet.password }
    password_confirmation { password }
  end
end
