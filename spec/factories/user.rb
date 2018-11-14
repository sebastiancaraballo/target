FactoryBot.define do
  factory :user do
    email                 { Faker::Internet.email }
    password              { 'password' }
    password_confirmation { 'password' }
    name                  { Faker::Name.name }
    gender                { User.genders.keys.sample }
    push_token            { ['123a4567-8a9a-12aa-a34a-5aa67a89aaaa'] }

    factory :user_with_conversations do
      transient do
        conversations_count { 3 }
      end

      after(:create) do |user, evaluator|
        create_list(:conversation, evaluator.conversations_count, users: [user])
      end
    end
  end
end
