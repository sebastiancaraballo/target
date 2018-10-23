require 'rails_helper'

describe 'GET api/v1/conversations/{id}/messages', type: :request do
  let(:user)            { create(:user) }
  let!(:conversation)   { create(:conversation_with_messages, users: [user]) }

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
end
