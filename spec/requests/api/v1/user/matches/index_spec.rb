require 'rails_helper'

describe 'GET api/v1/user/matches', type: :request do
  let(:user)      { create(:user) }
  let!(:matches)  { create_list(:match, 3, first_user_id: user.id) }
  before do
    get api_v1_user_matches_path, headers: auth_headers, as: :json
  end

  it 'returns matches' do
    matches.each do |match|
      expect(json).to include_json(
        matches: UnorderedArray(id: match.id,
                                first_user_id: user.id)
      )
    end
  end

  it 'returns a successful response' do
    expect(response).to have_http_status(:success)
  end
end
