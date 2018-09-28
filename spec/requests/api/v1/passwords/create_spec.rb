require 'rails_helper'

describe 'POST api/v1/users/passwords', type: :request do
  let!(:user) { create(:user) }

  context 'with valid email params' do
    let(:params) { { email: user.email } }

    it 'returns a successful response' do
      post user_password_path, params: params, as: :json
      expect(response).to have_http_status(:success)
    end

    it 'returns user mail message' do
      post user_password_path, params: params, as: :json
      expect(json[:message]).to match(user.email)
    end

    it 'sends an email' do
      expect { post user_password_path, params: params, as: :json }
        .to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end

  context 'with non-existent email params' do
    it 'does not return a succesful response' do
      post user_password_path, params: { email: 'nonexistent@mail.com' }, as: :json
      expect(response).to have_http_status(:not_found)
    end

    it 'does not send an email' do
      expect do
        post user_password_path, params: { email: 'nonexistent@mail.com' }, as: :json
      end.to change { ActionMailer::Base.deliveries.count }.by(0)
    end
  end
end
