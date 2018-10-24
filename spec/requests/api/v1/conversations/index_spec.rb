require 'rails_helper'

describe 'GET api/v1/conversations', type: :request do
  let(:user)            { create(:user_with_conversations) }
  let(:conversations)   { user.conversations }

  before do
    get api_v1_conversations_path, headers: auth_headers, as: :json
  end

  it 'returns conversations' do
    conversations.each do |conversation|
      expect(json).to include_json(
        conversations: UnorderedArray(id: conversation.id,
                                      match_id: conversation.match_id,
                                      unread_messages: conversation.unread_messages_count(user),
                                      last_message: conversation.last_message)
      )
    end
  end

  it 'returns a successful response' do
    expect(response).to have_http_status(:success)
  end
end
