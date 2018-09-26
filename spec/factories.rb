FactoryBot.define do
  factory :user do
    email                 { Faker::Internet.email }
    password              { 'password' }
    password_confirmation { 'password' }
    name                  { Faker::Name.name }
    gender                { User.genders.keys.sample }
  end
end
