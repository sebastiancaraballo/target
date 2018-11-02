require 'rails_helper'

describe 'PUT api/v1/users/:id', type: :request do
  let(:user)              { create(:user) }
  let(:new_email)         { 'test2@test.com' }
  let(:new_name)          { 'Test2' }
  let(:new_gender)        { 'female' }

  before do
    put api_v1_user_path(user), params: params, headers: auth_headers, as: :json
  end

  context 'with valid params' do
    let(:params) do
      {
        user: { email: new_email, name: new_name, gender: new_gender }
      }
    end

    it 'returns a succesful response' do
      expect(response).to have_http_status(:success)
    end

    it 'updates the user' do
      user.reload
      expect(user.email).to eq(new_email)
      expect(user.name).to eq(new_name)
      expect(user.gender).to eq(new_gender)
    end

    it 'returns the user' do
      expect(json[:user]).to include_json(
        id: user.id,
        email: new_email,
        name: new_name,
        gender: new_gender
      )
    end
  end

  context 'with invalid params' do
    let(:params) do
      {
        user: { email: 'invalid_email' }
      }
    end

    it 'does not return success' do
      expect(response).to have_http_status(:bad_request)
    end

    it 'does not update the user' do
      expect { user.reload }.to_not change(user, :email)
    end
  end
end
