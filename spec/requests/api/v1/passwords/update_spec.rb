require 'rails_helper'

describe 'PUT api/v1/users/passwords/', type: :request do
  let(:user) { create(:user) }
  let(:new_password) { 'password2' }
  let(:params) do
    {
      password: new_password,
      password_confirmation: new_password
    }
  end

  context 'with same passwords params' do
    it 'returns a successful response' do
      put user_password_path, params: params, headers: auth_headers, as: :json
      expect(response).to have_http_status(:success)
    end
  end

  context 'without matching passwords params' do
    it 'does not change password' do
      params[:password_confirmation] = 'differentpassword'
      put user_password_path, params: params, headers: auth_headers, as: :json
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
