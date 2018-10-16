FactoryBot.define do
  factory :match do
    spot
    association :first_user, factory: :user
    association :second_user, factory: :user
  end
end
