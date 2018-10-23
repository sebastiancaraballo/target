FactoryBot.define do
  factory :message do
    content { Faker::Lorem.sentence }
    conversation
    association :sender, factory: :user
  end
end
