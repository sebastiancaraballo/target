require 'rails_helper'

describe 'POST api/v1/users/sign_in', type: :request do
  let(:user) { create(:user) }

  context 'with correct params' do
    before do
      params = {
        user:
          {
            email: user.email,
            password: user.password
          }
      }
      post new_user_session_path, params: params, as: :json
    end

    it 'returns a succesful response' do
      expect(response).to have_http_status(:success)
    end

    it 'returns the user' do
      expect(json[:user]).to include_json(
        id: user.id,
        email: user.email,
        name: user.name,
        gender: user.gender
      )
    end

    it 'returns a valid client and access token' do
      token = response.header['access-token']
      client = response.header['client']
      expect(user.reload.valid_token?(token, client)).to be_truthy
    end
  end

  context 'with incorrect params' do
    it 'returns error' do
      params = {
        user:
          {
            email: user.email,
            password: 'incorrect_password'
          }
      }
      post new_user_session_path, params: params, as: :json
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
