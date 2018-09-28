require 'rails_helper'
describe 'GET api/v1/users/passwords/edit', type: :request do
  let(:user) { create(:user) }
  let(:password_token) { user.send(:set_reset_password_token) }
  let(:params) do
    {
      reset_password_token: password_token,
      redirect_url: ENV['PASSWORD_RESET_URL']
    }
  end

  it 'returns access token, uid and client id' do
    get edit_user_password_path, params: params
    expect(response.header['Location']).to include('token', 'uid', 'client_id')
  end
end
