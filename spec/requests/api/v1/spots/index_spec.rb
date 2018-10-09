require 'rails_helper'

describe 'GET api/v1/spots', type: :request do
  let(:user)            { create(:user) }
  let!(:spots)          { create_list(:spot, 3, user_id: user.id) }
  before do
    get api_v1_spots_path, headers: auth_headers, as: :json
  end

  it 'returns spots' do
    spots.each do |spot|
      expect(json).to include_json(
        spots: UnorderedArray(id: spot.id, title: spot.title,
                              latitude: format('%.6g', format('%.6f', spot.latitude)),
                              longitude: format('%.6g', format('%.6f', spot.longitude)),
                              radius: format('%.1f', spot.radius),
                              topic_id: spot.topic_id)
      )
    end
  end

  it 'returns a successful response' do
    expect(response).to have_http_status(:success)
  end
end
