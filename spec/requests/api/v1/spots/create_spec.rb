require 'rails_helper'

describe 'POST api/v1/spots', type: :request do
  shared_examples 'invalid params' do
    it 'does not create the spot' do
      expect do
        post api_v1_spots_path, params: params, headers: auth_headers, as: :json
      end.not_to change(Spot, :count)
    end

    it 'does not return a successful response' do
      post api_v1_spots_path, params: params, headers: auth_headers, as: :json
      expect(response).to have_http_status(:bad_request)
    end
  end

  shared_examples 'valid params' do
    it 'returns a succesful response' do
      post api_v1_spots_path, params: params, headers: auth_headers, as: :json
      expect(response).to have_http_status(:success)
    end
  end

  let(:user)   { create(:user) }
  let(:topic)  { create(:topic) }
  let(:spot)   { Spot.last }

  context 'with correct params' do
    let(:params) do
      {
        spot: attributes_for(:spot, topic_id: topic.id)
      }
    end

    it 'creates the spot' do
      expect do
        post api_v1_spots_path, params: params, headers: auth_headers, as: :json
      end.to change(Spot, :count).by(1)
    end

    it 'returns the spot' do
      post api_v1_spots_path, params: params, headers: auth_headers, as: :json
      expect(json[:spot]).to include_json(
        id: spot.id,
        latitude: spot.latitude,
        longitude: spot.longitude,
        radius: spot.radius,
        topic_id: spot.topic_id
      )
    end

    it_behaves_like 'valid params'
  end
  context 'with incorrect params' do
    context 'when title is blank' do
      let(:params) do
        {
          spot: attributes_for(:spot, title: nil, topic_id: topic.id)
        }
      end
      it_behaves_like 'invalid params'
    end

    context 'when latitude is blank' do
      let(:params) do
        {
          spot: attributes_for(:spot, latitude: nil, topic_id: topic.id)
        }
      end
      it_behaves_like 'invalid params'
    end

    context 'when longitude is blank' do
      let(:params) do
        {
          spot: attributes_for(:spot, longitude: nil, topic_id: topic.id)
        }
      end
      it_behaves_like 'invalid params'
    end

    context 'when radius is blank' do
      let(:params) do
        {
          spot: attributes_for(:spot, radius: nil, topic_id: topic.id)
        }
      end
      it_behaves_like 'invalid params'
    end

    context 'when radius is not greater than zero' do
      let(:params) do
        {
          spot: attributes_for(:spot, radius: 0, topic_id: topic.id)
        }
      end
      it_behaves_like 'invalid params'
    end

    context 'when exceeding 10th spot creation limit' do
      let!(:spots) { create_list(:spot, 10, user_id: user.id) }
      let(:params) do
        {
          spot: attributes_for(:spot, topic_id: topic.id, user_id: user.id)
        }
      end

      it 'returns error message' do
        post api_v1_spots_path, params: params, headers: auth_headers, as: :json
        expect(json[:errors][:base]).to include t('api.errors.spot_limit')
      end

      it_behaves_like 'invalid params'
    end
  end

  context 'when two spots match' do
    let(:matched_user) { create(:user, push_token: [Faker::Number.number(20)]) }
    let(:match) { Match.last }
    let!(:spot) do
      create(:spot,
             latitude: -34.906821,
             longitude: -56.201086,
             radius: 500,
             topic_id: topic.id,
             user_id: matched_user.id)
    end
    let(:params) do
      {
        spot: attributes_for(:spot,
                             latitude: -34.907603,
                             longitude: -56.201101,
                             radius: 500,
                             topic_id: topic.id)
      }
    end
    let(:service) do
      NotificationService.new
    end

    before do
      create_notification_mock(200, create_notification_ok_body)
    end

    it 'creates the match' do
      expect do
        post api_v1_spots_path, params: params, headers: auth_headers, as: :json
      end.to change(Match, :count).by(1)
    end

    it 'returns the match' do
      post api_v1_spots_path, params: params, headers: auth_headers, as: :json
      expect(json[:matches].first).to include_json(
        id: match.id,
        matched_user_id: match.second_user_id
      )
    end

    it 'sends the matched user a notification' do
      post api_v1_spots_path, params: params, headers: auth_headers, as: :json
      expect(WebMock).to have_requested(:post, ENV['ONESIGNAL_NOTIFICATIONS_URL'])
    end

    it_behaves_like 'valid params'
  end
end
