require 'rails_helper'

describe 'GET api/v1/users/:id', type: :request do
  let(:user)        { create(:user) }
  let(:other_user)  { create(:user) }
  before do
    get api_v1_user_path(other_user), headers: auth_headers, as: :json
  end

  it 'returns success' do
    expect(response).to have_http_status(:success)
  end

  it 'returns user data' do
    expect(json[:user]).to include_json(
      id: other_user.id,
      email: other_user.email,
      name: other_user.name,
      gender: other_user.gender
    )
  end
end
