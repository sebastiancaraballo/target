require 'rails_helper'

describe ConversationChannel, type: :channel do
  let(:user)          { create(:user) }
  let(:other_user)    { create(:user, push_token: [Faker::Number.number(20)]) }
  let(:match)         { create(:match, first_user: user, second_user: other_user) }
  let(:conversation)  { create(:conversation, users: [user, other_user], match: match) }
  let(:message)       { 'Hello, Rails!' }
  let(:params) do
    {
      conversation_id: conversation.id
    }
  end

  context 'with valid params' do
    let(:data) do
      {
        sender_id: user.id,
        conversation_id: conversation.id,
        message: message
      }
    end

    before do
      stub_connection(current_user: user)
      subscribe(params)
      create_notification_mock(200, create_notification_ok_body)
    end

    context 'when subscribing to existing conversations' do
      it 'successfully subscribes' do
        expect(subscription).to be_confirmed
      end
    end

    context 'when receives user message' do
      subject(:speak) do
        perform :speak,
                message: data[:message],
                sender_id: data[:sender_id],
                conversation_id: data[:conversation_id]
      end

      it 'saves message' do
        expect { speak }.to change(Message, :count).by(1)
      end

      it 'broadcasts the message to the conversation' do
        expect { speak }.to have_broadcasted_to(conversation)
          .from_channel(ConversationChannel)
          .with(a_hash_including(content: message))
      end

      it 'increments the other user unread messages' do
        expect do
          speak
          conversation.reload
        end.to change { conversation.second_user_unread_messages }.by(1)
      end

      it 'sends the addressee a notification' do
        speak
        expect(WebMock).to have_requested(:post, ENV['ONESIGNAL_NOTIFICATIONS_URL'])
      end
    end
  end

  context 'with invalid params' do
    let(:data) do
      {
        sender_id: user.id,
        conversation_id: conversation.id,
        message: message
      }
    end

    before do
      stub_connection(current_user: user)
    end

    context 'when subscribing with blank conversation_id' do
      let(:invalid_params) do
        {
          conversation_id: nil
        }
      end

      it 'rejects subscription' do
        subscribe(invalid_params)
        expect(subscription).to be_rejected
      end
    end

    context 'when receives a blank message' do
      subject(:speak) do
        perform :speak,
                message: blank_message,
                sender_id: data[:sender_id],
                conversation_id: data[:conversation_id]
      end

      let(:blank_message) { nil }

      it 'does not save the message' do
        subscribe(params)
        expect { speak }.to change(Message, :count).by(0)
      end

      it 'does not broadcast the message' do
        subscribe(params)

        expect { speak }.to_not have_broadcasted_to(conversation)
          .from_channel(ConversationChannel)
          .with(a_hash_including(content: blank_message))
      end

      it 'returns error' do
        subscribe(params)
        speak
        expect(connection.transmissions.last['error']).to eq t('api.errors.blank_message')
      end
    end
  end
end
