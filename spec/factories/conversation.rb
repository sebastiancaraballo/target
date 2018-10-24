FactoryBot.define do
  factory :conversation do
    match

    factory :conversation_with_messages do
      transient do
        messages_count { 3 }
      end

      after(:create) do |conversation, evaluator|
        create_list(:message, evaluator.messages_count, conversation: conversation)
      end
    end
  end
end
