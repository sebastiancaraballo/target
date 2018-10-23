require 'rails_helper'

describe 'POST api/v1/conversations', type: :request do
  shared_examples 'valid params' do
    it 'returns a succesful response' do
      post api_v1_conversations_path, params: params, headers: auth_headers, as: :json
      expect(response).to have_http_status(:success)
    end
  end

  let(:user)          { create(:user) }
  let(:match)         { create(:match) }
  let(:conversation)  { Conversation.last }

  context 'with correct params' do
    let(:params) do
      {
        conversation: attributes_for(:conversation, match_id: match.id)
      }
    end

    it 'creates the conversation' do
      expect do
        post api_v1_conversations_path, params: params, headers: auth_headers, as: :json
      end.to change(Conversation, :count).by(1)
    end

    it 'returns the conversation' do
      post api_v1_conversations_path, params: params, headers: auth_headers, as: :json
      expect(json[:conversation]).to include_json(
        id: conversation.id,
        match_id: conversation.match_id
      )
    end

    it_behaves_like 'valid params'
  end
end
