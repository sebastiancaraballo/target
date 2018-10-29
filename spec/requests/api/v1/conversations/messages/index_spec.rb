require 'rails_helper'

describe 'GET api/v1/conversations/{id}/messages', type: :request do
  let(:user)                 { create(:user) }
  let(:other_user)           { create(:user) }
  let(:match)                { create(:match, first_user: user, second_user: other_user) }
  let(:conversation)         { create(:conversation, users: [user, other_user], match: match) }
  let!(:user_messages) do
    create_list(:message, 2, sender: user, conversation: conversation)
  end
  let!(:other_user_messages) do
    create_list(:message, 2, sender: other_user, conversation: conversation)
  end

  before do
    get api_v1_conversation_messages_path(conversation),
        headers: auth_headers, as: :json
  end

  it 'returns messages' do
    conversation.messages.each do |message|
      expect(json).to include_json(
        messages: UnorderedArray(id: message.id,
                                 content: message.content,
                                 sender_id: message.sender_id)
      )
    end
  end

  it 'returns a successful response' do
    expect(response).to have_http_status(:success)
  end

  it 'marks first user unread messages as read' do
    conversation.reload
    expect(conversation.first_user_unread_messages).to be_zero
  end
end
