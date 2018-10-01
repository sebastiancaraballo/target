require 'rails_helper'

describe 'DELETE api/v1/users/sign_out', type: :request do
  let(:user) { create(:user) }

  it 'returns a succesful response' do
    delete destroy_user_session_path, headers: auth_headers, as: :json
    expect(response).to have_http_status(:success)
  end

  context 'when user is not logged in' do
    it 'returns error' do
      delete destroy_user_session_path, headers: headers, as: :json
      expect(response).to have_http_status(:not_found)
    end
  end
end
