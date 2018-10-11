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

    it 'returns a succesful response' do
      post api_v1_spots_path, params: params, headers: auth_headers, as: :json
      expect(response).to have_http_status(:success)
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
        expect(json[:errors][:base]).to include I18n.t('api.errors.spot_limit')
      end

      it_behaves_like 'invalid params'
    end
  end
end
