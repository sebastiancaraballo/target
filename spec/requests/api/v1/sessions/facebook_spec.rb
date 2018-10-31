require 'rails_helper'

describe 'POST api/v1/users/facebook', type: :request do
  let(:facebook_path) { api_v1_users_facebook_path }
  let(:params) { { access_token: '12345678' } }
  let(:user) { User.last }

  before do
    stub_request(:get, 'https://graph.facebook.com/me')
      .with(query: hash_including(
        'access_token': '12345678',
        'fields': 'email,first_name,last_name,gender'
      ))
      .to_return(status: 200, body: '{
          "email": "test@facebook.com",
          "first_name": "Jhon",
          "last_name": "Doe",
          "gender": "male",
          "id": "987654321"
        }')
  end

  shared_examples 'valid params' do
    it 'returns a succesful response' do
      post facebook_path, params: params, as: :json
      expect(response).to have_http_status(:success)
    end

    it 'returns a valid client and access token' do
      post facebook_path, params: params, as: :json
      token = response.headers['access-token']
      client = response.headers['client']
      expect(user.reload.valid_token?(token, client)).to be_truthy
    end
  end

  context 'when user logs in for the first time' do
    it 'creates a user' do
      expect do
        post facebook_path, params: params, as: :json
      end.to change(User, :count).by(1)
    end

    it 'creates user properly' do
      post facebook_path, params: params, as: :json
      expect(user.encrypted_password).to be_present
      expect(user.name).to eq 'Jhon Doe'
      expect(user.gender).to eq 'male'
      expect(user.email).to eq 'test@facebook.com'
    end

    it_behaves_like 'valid params'
  end

  context 'with already registered user with same email' do
    before do
      create(:user, email: 'test@facebook.com')
    end

    it 'does not return a succesful response' do
      post facebook_path, params: params, as: :json
      expect(response).to have_http_status(:bad_request)
    end

    it 'does not create a user' do
      expect do
        post facebook_path, params: params, as: :json
      end.not_to change(User, :count)
    end

    it 'returns error message' do
      post facebook_path, params: params, as: :json
      expect(json[:error]).to include t('api.errors.not_unique_user')
    end
  end

  context 'when user has previously logged in via Facebook' do
    before do
      params = {
        email: 'test@facebook.com',
        provider: 'facebook',
        uid: '987654321'
      }
      create :user, email: params[:email], provider: params[:provider], uid: params[:uid]
    end

    it 'does not create a user' do
      expect do
        post facebook_path, params: params, as: :json
      end.not_to change(User, :count)
    end

    it_behaves_like 'valid params'
  end
end
