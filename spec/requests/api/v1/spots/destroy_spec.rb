require 'rails_helper'

describe 'DELETE api/v1/spots/:id', type: :request do
  let(:user)            { create(:user) }
  let(:other_user)      { create(:user) }

  context 'when user deletes his own spot' do
    let!(:spot) { create(:spot, user_id: user.id) }

    it 'deletes the spot' do
      expect do
        delete api_v1_spot_path(id: spot.id), headers: auth_headers, as: :json
      end.to change(Spot, :count).by(-1)
    end

    it 'returns a successful response' do
      delete api_v1_spot_path(id: spot.id), headers: auth_headers, as: :json
      expect(response).to have_http_status(:success)
    end
  end

  context 'when user deletes other´s user spot' do
    let!(:spot) { create(:spot, user_id: other_user.id) }

    it 'does not delete the spot' do
      expect do
        delete api_v1_spot_path(id: spot.id), headers: auth_headers, as: :json
      end.not_to change(Spot, :count)
    end

    it 'returns unsuccessful response' do
      delete api_v1_spot_path(id: spot.id), headers: auth_headers, as: :json
      expect(response).to have_http_status(:not_found)
    end
  end
end
